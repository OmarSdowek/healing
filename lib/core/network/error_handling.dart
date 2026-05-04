import 'package:dio/dio.dart';
import 'api_exception.dart';

class ErrorHandler {
  static ApiException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: "Connection timeout",
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          message: "Send timeout",
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Receive timeout",
        );

      case DioExceptionType.badResponse:
        return ApiException(
          message: _extractMessage(error.response?.data) ??
              "Bad response from server",
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: "Request was cancelled",
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: "No Internet Connection",
        );
      case DioExceptionType.unknown:
        // Handle connection closed / network interruption
        final msg = error.message ?? '';
        if (msg.contains('Connection closed') ||
            msg.contains('Connection reset') ||
            msg.contains('SocketException')) {
          return ApiException(message: "Connection interrupted. Please try again.");
        }
        return ApiException(
          message: "Unknown error occurred",
        );
      default:
        return ApiException(
          message: "Unexpected error occurred",
        );
    }
  }

  /// Safely extract error message from any response data type
  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return data['message']?.toString() ??
          data['title']?.toString() ??
          data['detail']?.toString();
    }
    if (data is String && data.isNotEmpty) {
      // Avoid returning huge HTML pages
      if (data.length > 200) return null;
      return data;
    }
    return null;
  }
}