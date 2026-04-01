import 'package:flutter/material.dart';
import 'package:healing/features/patient/settings/presenatation/views/faqs_screen.dart';
import 'package:healing/features/patient/settings/presenatation/views/privacy_polices_screen.dart';
import '../../features/auth/presentation/view/sign_up_as.dart';
import '../../features/on_boarding/presentation/views/on_boarding.dart';
import '../../features/patient/auth/presentatiion/views/new_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_forget_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_otp_email.dart';
import '../../features/patient/auth/presentatiion/views/patient_sign_in.dart';
import '../../features/patient/auth/presentatiion/views/patient_verify_password.dart';
import '../../features/patient/auth/presentatiion/views/reset_password.dart';
import '../../features/patient/auth/presentatiion/views/sign_up_screen.dart';
import '../../features/patient/doctors/presentation/view/doctors_screen.dart';
import '../../features/patient/doctors/presentation/view/favourite_doctor.dart';
import '../../features/patient/home/layout_screen.dart';
import '../../features/doctor/appointments/presentation/view/today_appointments_screen.dart';
import '../../features/doctor/home/doctor_layout_screen.dart';
import '../../features/doctor/notifications/presentation/view/doctor_notifications_screen.dart';
import '../../features/doctor/prescription/presentation/view/add_prescription_screen.dart';
import '../../features/patient/home/presentation/view/specialties_screen.dart';
import '../../features/patient/profile/presentation/view/personal_information.dart';
import '../../features/patient/search/presentation/view/search.dart';
import '../../features/patient/settings/presenatation/views/mange_password_screen.dart';
import '../../features/patient/settings/presenatation/views/settings_screen.dart';
import '../../features/splash/presentation/view/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => OnBoarding());

      case Routes.signUpAs:
        return MaterialPageRoute(builder: (_) => SignUpAsScreen());

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

      // doctor home
      case Routes.doctorHome:
        return MaterialPageRoute(builder: (_) => DoctorMainScreen());

      case Routes.doctorNotifications:
        return MaterialPageRoute(
          builder: (_) => const DoctorNotificationsScreen(),
        );

      case Routes.todayAppointments:
        return MaterialPageRoute(
          builder: (_) => const TodayAppointmentsScreen(),
        );

      case Routes.addPrescription:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AddPrescriptionScreen(
            patientName: args['patientName'] as String,
            patientAge: args['patientAge'] as int,
            patientMrn: args['patientMrn'] as String,
            patientBloodType: args['patientBloodType'] as String,
            patientWeight: args['patientWeight'] as String,
            patientImage: args['patientImage'] as String,
          ),
        );
      case Routes.search:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case Routes.specialties:
        return MaterialPageRoute(builder: (_) => SpecialtiesScreen());
      case Routes.doctors:
        return MaterialPageRoute(builder: (_) => DoctorsScreen());
      case Routes.favorites:
        return MaterialPageRoute(builder: (_) => FavoritesDoctorsScreen());

      // patient settings

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case Routes.faqs:
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case Routes.mangePassword:
        return MaterialPageRoute(builder: (_) => ManagePasswordScreen());
      case Routes.personalInformation:
        return MaterialPageRoute(builder: (_) => PersonalInformationScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
