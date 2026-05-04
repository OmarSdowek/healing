import 'package:get_it/get_it.dart';
import 'package:healing/core/network/api_service.dart';

// Auth Repo
import 'package:healing/features/patient/auth/data/repo/repo_impl.dart';
import '../../features/patient/auth/domin/repo/auth_repo_interface.dart';

// Home Repo
import '../../features/patient/home/data/repo/home_repo_impl.dart';
import '../../features/patient/home/domin/repo/home_repo_interface.dart';

// Appointment Repo
import '../../features/patient/appointment/data/repo/appointment_repo_impl.dart';
import '../../features/patient/appointment/domin/repo/appointment_repo.dart';

// Booking Repo
import '../../features/patient/booking/data/repo/booking_repo_impl.dart';
import '../../features/patient/booking/domin/repo/booking_repo.dart';

// Medical Report Repo
import '../../features/patient/medical_report/data/repo/medical_report_repo_impl.dart';
import '../../features/patient/medical_report/domin/repo/medical_report_repo.dart';

// Payment Repo
import '../../features/patient/payment/data/repo/payment_repo_impl.dart';
import '../../features/patient/payment/domin/repo/payment_repo.dart';

// Notification Repo
import '../../features/patient/notifications/data/repo/notification_repo_impl.dart';
import '../../features/patient/notifications/domin/repo/notification_repo.dart';

// Auth UseCases
import 'package:healing/features/patient/auth/domin/use_case/register_use_case.dart';
import 'package:healing/features/patient/auth/domin/use_case/login_use_case.dart';
import 'package:healing/features/patient/auth/domin/use_case/email_verify.dart';
import 'package:healing/features/patient/auth/domin/use_case/reset_password_use_case.dart';
import 'package:healing/features/patient/auth/domin/use_case/patient_log_out_use_case.dart';
import '../../features/patient/auth/domin/use_case/delete_acount_use_case.dart';
import '../../features/patient/auth/domin/use_case/me_data_use_case.dart';
import '../../features/patient/auth/domin/use_case/patient_forget_password.dart';

// Home UseCases
import '../../features/patient/home/domin/use_cases/get_doctor_use_case.dart';
import '../../features/patient/home/domin/use_cases/get_departments_use_case.dart';
import '../../features/patient/home/domin/use_cases/get_doctors_by_department_use_case.dart';

// Appointment UseCases
import '../../features/patient/appointment/domin/use_cases/get_patient_appointments_use_case.dart';
import '../../features/patient/appointment/domin/use_cases/cancel_appointment_use_case.dart';
import '../../features/patient/appointment/domin/use_cases/get_appointment_by_id_use_case.dart';

// Booking UseCases
import '../../features/patient/booking/domin/use_cases/get_available_slots_use_case.dart';
import '../../features/patient/booking/domin/use_cases/book_appointment_use_case.dart';

// Medical Report UseCases
import '../../features/patient/medical_report/domin/use_cases/get_reports_use_case.dart';

// Payment UseCases
import '../../features/patient/payment/domin/use_cases/payment_use_cases.dart';
// Notification UseCases
import '../../features/patient/notifications/domin/use_cases/get_notifications_use_case.dart';

// Cubits
import 'package:healing/features/patient/auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../features/patient/home/presentation/manger/home_cubit/home_cubit.dart';
import '../../features/patient/appointment/presentation/manger/appointment_cubit.dart';
import '../../features/patient/booking/presentation/manger/booking_cubit.dart';
import '../../features/patient/medical_report/presentation/manger/medical_report_cubit.dart';
import '../../features/patient/payment/presenatation/manger/payment_cubit.dart';
import '../../features/patient/notifications/presentation/manger/notification_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ================= CORE =================
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // ================= REPOSITORIES =================

  sl.registerLazySingleton<AuthRepoInterface>(
    () => RepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<AppointmentRepo>(
    () => AppointmentRepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<BookingRepo>(
    () => BookingRepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<MedicalReportRepo>(
    () => MedicalReportRepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<PaymentRepo>(
    () => PaymentRepoImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(sl<ApiService>()),
  );

  // ================= USE CASES - AUTH =================

  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<VerifyEmailUseCaseImpl>(
    () => VerifyEmailUseCaseImpl(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<PatientForgetPassword>(
    () => PatientForgetPassword(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<PatientLogOutUseCase>(
    () => PatientLogOutUseCase(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<DeleteAcountUseCase>(
    () => DeleteAcountUseCase(sl<AuthRepoInterface>()),
  );
  sl.registerLazySingleton<MeDataUseCase>(
    () => MeDataUseCase(sl<AuthRepoInterface>()),
  );

  // ================= USE CASES - HOME =================

  sl.registerLazySingleton<GetDoctorUseCase>(
    () => GetDoctorUseCase(sl<HomeRepo>()),
  );
  sl.registerLazySingleton<GetDepartmentsUseCase>(
    () => GetDepartmentsUseCase(sl<HomeRepo>()),
  );
  sl.registerLazySingleton<GetDoctorsByDepartmentUseCase>(
    () => GetDoctorsByDepartmentUseCase(sl<HomeRepo>()),
  );

  // ================= USE CASES - APPOINTMENTS =================

  sl.registerLazySingleton<GetPatientAppointmentsUseCase>(
    () => GetPatientAppointmentsUseCase(sl<AppointmentRepo>()),
  );
  sl.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(sl<AppointmentRepo>()),
  );
  sl.registerLazySingleton<GetAppointmentByIdUseCase>(
    () => GetAppointmentByIdUseCase(sl<AppointmentRepo>()),
  );

  // ================= USE CASES - BOOKING =================

  sl.registerLazySingleton<GetAvailableSlotsUseCase>(
    () => GetAvailableSlotsUseCase(sl<BookingRepo>()),
  );
  sl.registerLazySingleton<BookAppointmentUseCase>(
    () => BookAppointmentUseCase(sl<BookingRepo>()),
  );

  // ================= USE CASES - MEDICAL REPORTS =================

  sl.registerLazySingleton<GetReportsUseCase>(
    () => GetReportsUseCase(sl<MedicalReportRepo>()),
  );
  sl.registerLazySingleton<GetReportDetailUseCase>(
    () => GetReportDetailUseCase(sl<MedicalReportRepo>()),
  );
  sl.registerLazySingleton<GetPrescriptionsUseCase>(
    () => GetPrescriptionsUseCase(sl<MedicalReportRepo>()),
  );
  sl.registerLazySingleton<GetActivePrescriptionsUseCase>(
    () => GetActivePrescriptionsUseCase(sl<MedicalReportRepo>()),
  );

  // ================= USE CASES - PAYMENT =================

  sl.registerLazySingleton<CreateInvoiceUseCase>(
    () => CreateInvoiceUseCase(sl<PaymentRepo>()),
  );
  sl.registerLazySingleton<IssueInvoiceUseCase>(
    () => IssueInvoiceUseCase(sl<PaymentRepo>()),
  );
  sl.registerLazySingleton<CreatePaymentIntentUseCase>(
    () => CreatePaymentIntentUseCase(sl<PaymentRepo>()),
  );
  sl.registerLazySingleton<ConfirmCashPaymentUseCase>(
    () => ConfirmCashPaymentUseCase(sl<PaymentRepo>()),
  );

  // ================= USE CASES - NOTIFICATIONS =================

  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(sl<NotificationRepo>()),
  );

  // ================= CUBITS =================

  sl.registerFactory<PatientAuthCubit>(
    () => PatientAuthCubit(
      sl<RegisterUseCase>(),
      sl<LoginUseCase>(),
      sl<VerifyEmailUseCaseImpl>(),
      sl<PatientForgetPassword>(),
      sl<ResetPasswordUseCase>(),
      sl<PatientLogOutUseCase>(),
      sl<DeleteAcountUseCase>(),
      sl<MeDataUseCase>(),
    ),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      sl<GetDoctorUseCase>(),
      sl<GetDepartmentsUseCase>(),
      sl<GetDoctorsByDepartmentUseCase>(),
    ),
  );

  sl.registerFactory<AppointmentCubit>(
    () => AppointmentCubit(
      sl<GetPatientAppointmentsUseCase>(),
      sl<CancelAppointmentUseCase>(),
    ),
  );

  sl.registerFactory<BookingCubit>(
    () => BookingCubit(
      sl<GetAvailableSlotsUseCase>(),
      sl<BookAppointmentUseCase>(),
      sl<GetDoctorUseCase>(),
    ),
  );

  sl.registerFactory<MedicalReportCubit>(
    () => MedicalReportCubit(
      sl<GetReportsUseCase>(),
      sl<GetReportDetailUseCase>(),
      sl<GetPrescriptionsUseCase>(),
      sl<GetActivePrescriptionsUseCase>(),
    ),
  );

  sl.registerFactory<PaymentCubit>(
    () => PaymentCubit(
      createInvoiceUseCase: sl<CreateInvoiceUseCase>(),
      issueInvoiceUseCase: sl<IssueInvoiceUseCase>(),
      createPaymentIntentUseCase: sl<CreatePaymentIntentUseCase>(),
      confirmCashPaymentUseCase: sl<ConfirmCashPaymentUseCase>(),
    ),
  );

  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      getAppointmentsUseCase: sl<GetPatientAppointmentsUseCase>(),
      notificationRepo: sl<NotificationRepo>(),
    ),
  );
}
