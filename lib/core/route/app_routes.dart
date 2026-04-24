import 'package:flutter/material.dart';
import 'package:healing/core/route/auth_guard.dart';
import 'package:healing/features/patient/prescription/presentation/view/prescription_screen.dart';
import 'package:healing/features/patient/settings/presenatation/views/faqs_screen.dart';
import 'package:healing/features/patient/settings/presenatation/views/privacy_polices_screen.dart';
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
import '../../features/patient/auth/presentatiion/views/new_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_forget_password.dart';
import '../../features/patient/auth/presentatiion/views/patient_otp_email.dart';
import '../../features/patient/auth/presentatiion/views/patient_sign_in.dart';
import '../../features/patient/auth/presentatiion/views/patient_verify_password.dart';
import '../../features/patient/auth/presentatiion/views/reset_password.dart';
import '../../features/patient/auth/presentatiion/views/sign_up_screen.dart';
import '../../features/patient/booking/presentation/views/confirm_booking.dart';
import '../../features/patient/booking/presentation/views/pay_booking_screen.dart';
import '../../features/patient/doctors/presentation/view/doctors_screen.dart';
import '../../features/patient/doctors/presentation/view/favourite_doctor.dart';
import '../../features/patient/home/layout_screen.dart';
import '../../features/doctor/appointments/presentation/view/today_appointments_screen.dart';
import '../../features/doctor/home/doctor_layout_screen.dart';
import '../../features/doctor/notifications/presentation/view/doctor_notifications_screen.dart';
import '../../features/doctor/prescription/presentation/view/add_prescription_screen.dart';
import '../../features/patient/home/presentation/view/specialties_screen.dart';
import '../../features/patient/medical_report/domin/entity/medical_report_model.dart';
import '../../features/patient/medical_report/presentation/view/medical_report_details.dart';
import '../../features/patient/medical_report/presentation/view/medical_report_screen.dart';
import '../../features/patient/notifications/presentation/view/patient_notifications_screen.dart';
import '../../features/patient/payment/presenatation/view/add_new_card.dart';
import '../../features/patient/profile/presentation/view/personal_information.dart';
import '../../features/patient/search/presentation/view/search.dart';
import '../../features/patient/settings/presenatation/views/mange_password_screen.dart';
import '../../features/patient/settings/presenatation/views/settings_screen.dart';
import '../../features/splash/presentation/view/splash_screen.dart';
import '../constant/assets_manger.dart';
import 'routes.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

Route<dynamic> _doctor(Widget screen) =>
    MaterialPageRoute(builder: (_) => AuthGuard(isDoctor: true, child: screen));

Route<dynamic> _patient(Widget screen) =>
    MaterialPageRoute(builder: (_) => AuthGuard(child: screen));

Route<dynamic> _public(Widget screen) =>
    MaterialPageRoute(builder: (_) => screen);

// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ── Public ──────────────────────────────────────────────────────────────
      case Routes.splash:
        return _public(const SplashScreen());
      case Routes.onboarding:
        return _public(OnBoarding());
      case Routes.signUpAs:
        return _public(const SignUpAsScreen());

      // ── Patient Auth (public) ────────────────────────────────────────────────
      case Routes.patientLogin:
        return _public(PatientSignIn());
      case Routes.patientRegister:
        return _public(PatientSignUpScreen());
      case Routes.verifyEmail:
        return _public(PatientOtpEmail());
      case Routes.forgotPassword:
        return _public(PatientForgotPassword());
      case Routes.resetPassword:
        return _public(PatientResetPassword());
      case Routes.setNewPassword:
        return _public(PatientSetNewPassword());
      case Routes.verifyCode:
        return _public(PatientVerifyPassword());

      // ── Doctor Auth (public) ─────────────────────────────────────────────────
      case Routes.doctorLogin:
        return _public(const DoctorSignIn());
      case Routes.doctorRegister:
        return _public(const DoctorSignUpScreen());
      case Routes.doctorVerifyEmail:
        return _public(DoctorOtpEmail());
      case Routes.doctorForgotPassword:
        return _public(const DoctorForgotPassword());
      case Routes.doctorResetPassword:
        return _public(DoctorResetPassword());
      case Routes.doctorSetNewPassword:
        return _public(const DoctorSetNewPassword());
      case Routes.doctorVerifyCode:
        return _public(DoctorVerifyPassword());

      // ── Patient Protected ────────────────────────────────────────────────────
      case Routes.patientHome:
        return _patient(MainScreen());
      case Routes.search:
        return _patient(SearchScreen());
      case Routes.specialties:
        return _patient(SpecialtiesScreen());
      case Routes.doctors:
        return _patient(DoctorsScreen());
      case Routes.favorites:
        return _patient(FavoritesDoctorsScreen());
      case Routes.settings:
        return _patient(SettingsScreen());
      case Routes.faqs:
        return _patient(FaqsScreen());
      case Routes.privacyPolicy:
        return _patient(PrivacyPolicyScreen());
      case Routes.mangePassword:
        return _patient(ManagePasswordScreen());
      case Routes.personalInformation:
        return _patient(PersonalInformationScreen());
      case Routes.patientNotification:
        return _patient(PatientNotificationsScreen());
      case Routes.patientMedicalReport:
        return _patient(MedicalReportListScreen());
      case Routes.patientMedicalReportDetails:
        final report = settings.arguments as MedicalReport;
        return _patient(MedicalReportDetailScreen(report: report));
      case Routes.addNewCard:
        return _patient(const AddNewCardScreen());
      case Routes.pay:
        return _patient(
          PaymentScreen(
            doctorName: "Mohamed Saeed",
            speciality: "Physical Therapy",
            image: AssetsManger.doctor3Image,
            appointmentDate: DateTime(2024, 7, 17, 16, 0),
          ),
        );
      case Routes.myAppointments:
        return _patient(const MyAppointment());
      case Routes.upComingOppointment:
        return _patient(const UpComingOppointment());
      case Routes.prescriptionDetails:
        return _patient(const PrescriptionScreen());
      case Routes.appointmentConfirmation:
        return _patient(const ConfirmBooking());

      // ── Doctor Protected ─────────────────────────────────────────────────────
      case Routes.doctorHome:
        return _doctor(const DoctorMainScreen());
      case Routes.doctorNotifications:
        return _doctor(const DoctorNotificationsScreen());
      case Routes.todayAppointments:
        return _doctor(const TodayAppointmentsScreen());
      case Routes.addPrescription:
        final args = settings.arguments as Map<String, dynamic>;
        return _doctor(
          AddPrescriptionScreen(
            patientName: args['patientName'] as String,
            patientAge: args['patientAge'] as int,
            patientMrn: args['patientMrn'] as String,
            patientBloodType: args['patientBloodType'] as String,
            patientWeight: args['patientWeight'] as String,
            patientImage: args['patientImage'] as String,
          ),
        );
      case Routes.doctorProfile:
        return _doctor(const DoctorProfileScreen());
      case Routes.doctorPersonalInformation:
        return _doctor(const DoctorPersonalInformation());
      case Routes.doctorManagePassword:
        return _doctor(const DoctorManagePasswordScreen());
      case Routes.doctorFaqs:
        return _doctor(const DoctorFaqsScreen());
      case Routes.doctorPrivacyPolicy:
        return _doctor(const DoctorPrivacyPolicyScreen());
      case Routes.doctorSettings:
        return _doctor(const DoctorSettingsScreen());

      // ── Fallback ─────────────────────────────────────────────────────────────
      default:
        return _public(
          const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
