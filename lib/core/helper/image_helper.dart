import '../constant/api_endpoint.dart';

/// Resolves a picture URL from the backend.
///
/// Handles:
/// - localhost:PORT → replaced with ngrok base URL
/// - 10.0.2.2 (Android emulator) → replaced with ngrok base URL
/// - Valid remote URLs → returned as-is
/// - Empty/null → returns null (caller shows fallback)
String? resolveImageUrl(String? url) {
  if (url == null || url.isEmpty) return null;

  String resolved = url;

  // Replace localhost variants (any port) with the ngrok base URL
  resolved = resolved.replaceAllMapped(
    RegExp(r'https?://localhost(:\d+)?'),
    (_) => ApiEndpoints.baseUrl,
  );

  // Replace Android emulator host with ngrok base URL
  resolved = resolved.replaceAllMapped(
    RegExp(r'https?://10\.0\.2\.2(:\d+)?'),
    (_) => ApiEndpoints.baseUrl,
  );

  // Replace 127.0.0.1 variants
  resolved = resolved.replaceAllMapped(
    RegExp(r'https?://127\.0\.0\.1(:\d+)?'),
    (_) => ApiEndpoints.baseUrl,
  );

  // If still contains localhost/local IP after replace, return null
  if (resolved.contains('localhost') ||
      resolved.contains('10.0.2.2') ||
      resolved.contains('127.0.0.1')) {
    return null;
  }

  // Must be a valid http/https URL
  if (!resolved.startsWith('http')) return null;

  // Reject obvious placeholder values from Swagger/API (e.g. "string", "url", "image")
  final path = Uri.tryParse(resolved)?.path ?? '';
  const placeholders = {'string', 'url', 'image', 'photo', 'picture', 'null', 'undefined'};
  if (placeholders.contains(path.replaceAll('/', '').toLowerCase())) return null;

  return resolved;
}

/// Returns true if the URL resolves to a valid remote image
bool isRemoteImage(String? url) {
  final resolved = resolveImageUrl(url);
  return resolved != null && resolved.startsWith('http');
}
