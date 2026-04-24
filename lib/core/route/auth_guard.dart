import 'package:flutter/material.dart';
import 'package:healing/core/network/token_storage.dart';
import 'package:healing/core/route/routes.dart';

/// Wraps a protected screen. On first build it checks for a valid token.
/// If no token → redirects to the appropriate login screen.
class AuthGuard extends StatefulWidget {
  final Widget child;
  final bool isDoctor;

  const AuthGuard({super.key, required this.child, this.isDoctor = false});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final token = await TokenStorage.getAccessToken();
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      final loginRoute = widget.isDoctor
          ? Routes.doctorLogin
          : Routes.patientLogin;
      Navigator.pushReplacementNamed(context, loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
