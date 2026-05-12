import 'package:flutter/material.dart';

/// Unified snackbar helper for consistent error/success/info messages.
class AppSnackBar {
  AppSnackBar._();

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFFDC2626),
      icon: Icons.error_outline_rounded,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF16A34A),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFF2563EB),
      icon: Icons.info_outline_rounded,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: const Color(0xFFD97706),
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: duration,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white70,
          onPressed: () =>
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}
