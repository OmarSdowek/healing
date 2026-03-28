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
          message: error.response?.data["message"] ??
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
        return ApiException(
          message: "Unknown error occurred",
        );
      default:
        return ApiException(
          message: "Unexpected error occurred",
        );
    }
  }
}