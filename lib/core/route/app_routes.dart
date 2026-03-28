import 'package:flutter/material.dart';
import '../../features/auth/presentation/view/sign_up_as.dart';
import '../../features/on_boarding/presentation/views/on_boarding.dart';
import '../../features/patient/auth/presentatiion/views/new_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_forget_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_otp_email.dart';
import '../../features/patient/auth/presentatiion/views/patient_sign_in.dart';
import '../../features/patient/auth/presentatiion/views/patient_verify_password.dart';
import '../../features/patient/auth/presentatiion/views/reset_password.dart';
import '../../features/patient/auth/presentatiion/views/sign_up_screen.dart';
import '../../features/patient/home/layout_screen.dart';
import '../../features/patient/search/presentation/view/search.dart';
import '../../features/splash/presentation/view/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) =>  SplashScreen(),
        );
        case Routes.onboarding:
      return MaterialPageRoute(
        builder: (_) =>  OnBoarding(),
      );

      case Routes.signUpAs:
        return MaterialPageRoute(
          builder: (_) => SignUpAsScreen(),
        );

      case Routes.patientLogin:
        return MaterialPageRoute(builder: (_) => PatientSignIn());

      case Routes.patientRegister:
        return MaterialPageRoute(builder: (_) => PatientSignUpScreen());

      case Routes.verifyEmail:
        return MaterialPageRoute(builder: (_) => PatientOtpEmail());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => PatientForgotPassword());

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => PatientResetPassword());

      case Routes.setNewPassword:
        return MaterialPageRoute(builder: (_) => PatientSetNewPassword());

      case Routes.verifyCode:
        return MaterialPageRoute(builder: (_) => PatientVerifyPassword());


        // patienthome

        case Routes.patientHome:
      return MaterialPageRoute(builder: (_) => MainScreen());
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}