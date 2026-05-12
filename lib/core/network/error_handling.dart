import 'package:dio/dio.dart';
import 'api_exception.dart';

class ErrorHandler {
  static ApiException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: UserFriendlyErrors.timeout,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final serverMsg = _extractMessage(error.response?.data);
        return ApiException(
          message: UserFriendlyErrors.fromStatusCode(statusCode, serverMsg),
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(message: UserFriendlyErrors.cancelled);

      case DioExceptionType.connectionError:
        return ApiException(message: UserFriendlyErrors.noInternet);

      case DioExceptionType.unknown:
        final msg = error.message ?? '';
        if (msg.contains('Connection closed') ||
            msg.contains('Connection reset') ||
            msg.contains('SocketException') ||
            msg.contains('Failed host lookup')) {
          return ApiException(message: UserFriendlyErrors.noInternet);
        }
        return ApiException(message: UserFriendlyErrors.unknown);

      default:
        return ApiException(message: UserFriendlyErrors.unknown);
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      // Try common error fields
      final msg = data['message']?.toString() ??
          data['detail']?.toString() ??
          data['title']?.toString();
      if (msg != null && msg.length <= 300) return msg;
    }
    if (data is String && data.isNotEmpty && data.length <= 200) {
      return data;
    }
    return null;
  }
}

/// Human-readable error messages for all app scenarios.
class UserFriendlyErrors {
  UserFriendlyErrors._();

  // ── Network ───────────────────────────────────────────────────────────────
  static const String noInternet =
      'No internet connection. Please check your network and try again.';
  static const String timeout =
      'The request took too long. Please try again.';
  static const String cancelled = 'Request was cancelled.';
  static const String unknown =
      'Something went wrong. Please try again later.';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String invalidCredentials =
      'Incorrect email or password. Please try again.';
  static const String emailNotVerified =
      'Please verify your email before logging in.';
  static const String accountLocked =
      'Your account has been locked. Please contact support.';
  static const String sessionExpired =
      'Your session has expired. Please log in again.';
  static const String unauthorized =
      'You are not authorized to perform this action.';

  // ── Booking ───────────────────────────────────────────────────────────────
  static const String slotUnavailable =
      'This time slot is no longer available. Please choose another.';
  static const String appointmentConflict =
      'You already have an appointment at this time.';
  static const String cannotCancelTooLate =
      'Appointments cannot be cancelled less than 2 hours before the scheduled time.';
  static const String appointmentNotFound =
      'Appointment not found. It may have been cancelled.';

  // ── Medical ───────────────────────────────────────────────────────────────
  static const String allergyConflict =
      'This medication conflicts with a known patient allergy. Please choose a different medication.';
  static const String recordNotFound =
      'Medical record not found.';
  static const String invalidTransition =
      'This action cannot be performed on the current appointment status.';

  // ── General ───────────────────────────────────────────────────────────────
  static const String notFound = 'The requested item was not found.';
  static const String serverError =
      'A server error occurred. Please try again later.';
  static const String forbidden =
      'You do not have permission to access this.';
  static const String validationError =
      'Please check your input and try again.';

  /// Maps HTTP status code + optional server message to a user-friendly string.
  static String fromStatusCode(int? code, String? serverMsg) {
    // Check server message for specific known errors first
    if (serverMsg != null) {
      final lower = serverMsg.toLowerCase();

      if (lower.contains('allergy') || lower.contains('allergen')) {
        return allergyConflict;
      }
      if (lower.contains('slot') && lower.contains('available')) {
        return slotUnavailable;
      }
      if (lower.contains('cancel') && lower.contains('2 hour')) {
        return cannotCancelTooLate;
      }
      if (lower.contains('email') && lower.contains('verif')) {
        return emailNotVerified;
      }
      if (lower.contains('invalid') &&
          (lower.contains('password') || lower.contains('credential'))) {
        return invalidCredentials;
      }
      if (lower.contains('visit date') && lower.contains('future')) {
        return 'Visit date cannot be in the future. Please check the date.';
      }
      if (lower.contains('conflict') || lower.contains('already exist')) {
        return appointmentConflict;
      }
      if (lower.contains('transition') || lower.contains('status')) {
        return invalidTransition;
      }
    }

    // Fall back to status code mapping
    switch (code) {
      case 400:
        return validationError;
      case 401:
        return sessionExpired;
      case 403:
        return forbidden;
      case 404:
        return notFound;
      case 409:
        return appointmentConflict;
      case 422:
        return serverMsg != null && serverMsg.length <= 200
            ? serverMsg
            : validationError;
      case 500:
      case 502:
      case 503:
        return serverError;
      default:
        return unknown;
    }
  }
}
