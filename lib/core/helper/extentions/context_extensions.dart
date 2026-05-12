import 'package:flutter/material.dart';
import '../../widgets/app_snack_bar.dart';

/// Extension on BuildContext for quick snackbar access.
extension SnackBarExtension on BuildContext {
  void showError(String message) => AppSnackBar.showError(this, message);
  void showSuccess(String message) => AppSnackBar.showSuccess(this, message);
  void showInfo(String message) => AppSnackBar.showInfo(this, message);
  void showWarning(String message) => AppSnackBar.showWarning(this, message);
}
