import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/view/sign_up_as.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_forget_password.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_new_password.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_otp_email.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_reset_password.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_sign_in.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_sign_up_screen.dart';
import '../../features/doctor/auth/presentatiion/views/doctor_verify_password.dart';
import '../../features/doctor/profile/presentation/view/doctor_mange_password_screen.dart';
import '../../features/doctor/profile/presentation/view/doctor_personal_information.dart';
import '../../features/doctor/profile/presentation/view/doctor_profile_screen.dart';
import '../../features/doctor/settings/presenatation/views/doctor_faqs_screen.dart';
import '../../features/doctor/settings/presenatation/views/doctor_privacy_polices_screen.dart';
import '../../features/doctor/settings/presenatation/views/doctor_settings_screen.dart';
import '../../features/on_boarding/presentation/views/on_boarding.dart';
import '../../features/patient/appointment/presentation/view/my_appointemetn.dart';
import '../../features/patient/appointment/presentation/view/up_coming_oppointment.dart';
import '../../features/patient/auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../features/patient/auth/presentatiion/views/new_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_forget_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_otp_email.dart';
import '../../features/patient/auth/presentatiion/views/patient_sign_in.dart';
import '../../features/patient/auth/presentatiion/views/patient_verify_password.dart';
import '../../features/patient/auth/presentatiion/views/reset_password.dart';
import '../../features/patient/auth/presentatiion/views/sign_up_screen.dart';
import '../../features/patient/booking/presentation/views/booking_screen.dart';
import '../../features/patient/booking/presentation/views/confirm_booking.dart';
import '../../features/patient/booking/presentation/views/pay_booking_screen.dart';
import '../../features/patient/doctors/presentation/view/doctors_screen.dart';
import '../../features/patient/doctors/presentation/view/doctors_by_department_screen.dart';
import '../../features/patient/doctors/presentation/view/favourite_doctor.dart';
import '../../features/patient/home/layout_screen.dart';
import '../../features/patient/home/domin/entity/doctor_entity.dart';
import '../../features/doctor/appointments/presentation/view/today_appointments_screen.dart';
import '../../features/doctor/home/doctor_layout_screen.dart';
import '../../features/doctor/notifications/presentation/view/doctor_notifications_screen.dart';
import '../../features/doctor/prescription/presentation/view/add_prescription_screen.dart';
import '../../features/patient/home/presentation/view/specialties_screen.dart';
import '../../features/patient/medical_report/presentation/view/medical_report_details.dart';
import '../../features/patient/medical_report/presentation/view/medical_report_screen.dart';
import '../../features/patient/notifications/presentation/view/patient_notifications_screen.dart';
import '../../features/patient/payment/presenatation/view/add_new_card.dart';
import '../../features/patient/prescription/presentation/view/prescription_screen.dart';
import '../../features/patient/profile/presentation/view/personal_information.dart';
import '../../features/patient/search/presentation/view/search.dart';
import '../../features/patient/settings/presenatation/views/faqs_screen.dart';
import '../../features/patient/settings/presenatation/views/mange_password_screen.dart';
import '../../features/patient/settings/presenatation/views/privacy_polices_screen.dart';
import '../../features/patient/settings/presenatation/views/settings_screen.dart';
import '../../features/splash/presentation/view/splash_screen.dart';
import '../constant/assets_manger.dart';
import '../di/injection_container.dart';
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

      // patient auth

      case Routes.patientLogin:
        return MaterialPageRoute(builder: (_) => PatientSignIn());

      case Routes.patientRegister:
        return MaterialPageRoute(builder: (_) => PatientSignUpScreen());

      case Routes.verifyEmail:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final token = args['token'] as String? ?? '';
        final email = args['email'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => PatientOtpEmail(token: token, email: email),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<PatientAuthCubit>(),
            child: PatientForgotPassword(),
          ),
        );

      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => PatientResetPassword());

      case Routes.setNewPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl<PatientAuthCubit>(),
            child: PatientSetNewPassword(),
          ),
        );

      case Routes.verifyCode:
        return MaterialPageRoute(builder: (_) => PatientVerifyPassword());

      // doctor auth

      case Routes.doctorLogin:
        return MaterialPageRoute(builder: (_) => DoctorSignIn());

      case Routes.doctorRegister:
        return MaterialPageRoute(builder: (_) => DoctorSignUpScreen());

      case Routes.doctorVerifyEmail:
        return MaterialPageRoute(builder: (_) => DoctorOtpEmail());

      case Routes.doctorForgotPassword:
        return MaterialPageRoute(builder: (_) => DoctorForgotPassword());

      case Routes.doctorResetPassword:
        return MaterialPageRoute(builder: (_) => DoctorResetPassword());

      case Routes.doctorSetNewPassword:
        return MaterialPageRoute(builder: (_) => DoctorSetNewPassword());

      case Routes.doctorVerifyCode:
        return MaterialPageRoute(builder: (_) => DoctorVerifyPassword());

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
      case Routes.booking:
        final doctor = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BookAppointmentScreen(
            doctor: doctor is DoctorEntity ? doctor : null,
          ),
        );
      case Routes.doctors:
        return MaterialPageRoute(builder: (_) => DoctorsScreen());
      case Routes.doctorsByDepartment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DoctorsByDepartmentScreen(
            departmentId: args['departmentId'] as int,
            departmentName: args['departmentName'] as String,
          ),
        );
      case Routes.favorites:
        return MaterialPageRoute(builder: (_) => FavoritesDoctorsScreen());

      // patient settings

      case Routes.settings:
        // ✅ Provide PatientAuthCubit for delete account functionality
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PatientAuthCubit>()..meData(),
            child: const SettingsScreen(),
          ),
        );
      case Routes.faqs:
        return MaterialPageRoute(builder: (_) => FaqsScreen());
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case Routes.mangePassword:
        return MaterialPageRoute(builder: (_) => ManagePasswordScreen());
      case Routes.personalInformation:
        // ✅ Create new PatientAuthCubit instance and load data
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PatientAuthCubit>()..meData(),
            child: const PersonalInformationScreen(),
          ),
        );
      case Routes.patientNotification:
        return MaterialPageRoute(builder: (_) => PatientNotificationsScreen());
      case Routes.patientMedicalReport:
        return MaterialPageRoute(builder: (_) => const MedicalReportListScreen());
      case Routes.patientMedicalReportDetails:
        final reportId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => MedicalReportDetailScreen(reportId: reportId),
        );

      // patient payment

      case Routes.addNewCard:
        return MaterialPageRoute(builder: (_) => const AddNewCardScreen());
      case Routes.pay:
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            doctorName: "Mohamed Saeed",
            speciality: "Physical Therapy",
            image: AssetsManger.doctor3Image,
            appointmentDate: DateTime(2024, 7, 17, 16, 0),
          ),
        );

      // patient appointment

      case Routes.myAppointments:
        return MaterialPageRoute(builder: (_) => const MyAppointment());
      case Routes.upComingOppointment:
        return MaterialPageRoute(builder: (_) => const UpComingOppointment());
      case Routes.prescriptionDetails:
        return MaterialPageRoute(builder: (_) => const PrescriptionScreen());
      case Routes.appointmentConfirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        final doctor = args?['doctor'] as DoctorEntity?;
        if (doctor == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("Missing booking data")),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ConfirmBooking(
            doctor: doctor,
            date: args?['date'] as String? ?? '',
            startTime: args?['startTime'] as String? ?? '',
            endTime: args?['endTime'] as String? ?? '',
            patientId: args?['patientId'] as int? ?? 1,
          ),
        );

      // doctor profile

      case Routes.doctorProfile:
        return MaterialPageRoute(builder: (_) => DoctorProfileScreen());
      case Routes.doctorPersonalInformation:
        return MaterialPageRoute(builder: (_) => DoctorPersonalInformation());
      case Routes.doctorManagePassword:
        return MaterialPageRoute(builder: (_) => DoctorManagePasswordScreen());
      case Routes.doctorFaqs:
        return MaterialPageRoute(builder: (_) => DoctorFaqsScreen());
      case Routes.doctorPrivacyPolicy:
        return MaterialPageRoute(builder: (_) => DoctorPrivacyPolicyScreen());
      case Routes.doctorSettings:
        return MaterialPageRoute(builder: (_) => DoctorSettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
