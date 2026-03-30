import 'package:flutter/material.dart';
import 'package:healing/features/patient/prescription/presentation/view/prescription_screen.dart';
import 'package:healing/features/patient/settings/presenatation/views/faqs_screen.dart';
import 'package:healing/features/patient/settings/presenatation/views/privacy_polices_screen.dart';
import '../../features/auth/presentation/view/sign_up_as.dart';
import '../../features/on_boarding/presentation/views/on_boarding.dart';
import '../../features/patient/appointment/presentation/view/my_appointemetn.dart';
import '../../features/patient/appointment/presentation/view/up_coming_oppointment.dart';
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
import '../../features/patient/home/presentation/view/specialties_screen.dart';
import '../../features/patient/payment/presenatation/view/selected_card.dart';
import '../../features/patient/payment/presenatation/view/add_new_card.dart';
import '../../features/patient/payment/presenatation/view/payment_methods.dart';
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

       // patient payment

      case Routes.paymentMethod:
        return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
      case Routes.addNewCard:
        return MaterialPageRoute(builder: (_) => const AddNewCardScreen());
      case Routes.selectedCard:
        return MaterialPageRoute(builder: (_) => const SelectedCardScreen());

      // patient appointment

      case Routes.myAppointments:
        return MaterialPageRoute(builder: (_) => const MyAppointment());
      case Routes.upComingOppointment:
        return MaterialPageRoute(builder: (_) => const UpComingOppointment());
      case Routes.prescriptionDetails:
        return MaterialPageRoute(builder: (_) => const PrescriptionScreen());






      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
