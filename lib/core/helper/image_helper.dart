/// Resolves a picture URL from the backend.
/// - Replaces localhost with 10.0.2.2 for Android emulator
/// - Returns null if the URL is empty or still points to localhost
///   (so the caller can show a default/fallback image)
String? resolveImageUrl(String? url) {
  if (url == null || url.isEmpty) return null;

  // Replace localhost variants with Android emulator host
  final resolved = url
      .replaceFirst('http://localhost', 'http://10.0.2.2')
      .replaceFirst('https://localhost', 'http://10.0.2.2');

  // If still localhost after replace (edge case), return null → show default
  if (resolved.contains('localhost')) return null;

  return resolved;
}

/// Returns true if the URL is a valid remote URL (not localhost)
bool isRemoteImage(String? url) {
  final resolved = resolveImageUrl(url);
  return resolved != null && resolved.startsWith('http');
}
