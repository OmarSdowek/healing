import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/doctor_auth_repository_impl.dart';
import '../../domain/usecases/doctor_change_password_usecase.dart';
import '../../domain/usecases/doctor_forgot_password_usecase.dart';
import '../../domain/usecases/doctor_login_usecase.dart';
import '../../domain/usecases/doctor_logout_usecase.dart';
import '../../domain/usecases/doctor_register_usecase.dart';
import '../../domain/usecases/doctor_reset_password_usecase.dart';
import '../../domain/usecases/doctor_verify_email_usecase.dart';
import 'doctor_auth_cubit.dart';

class DoctorAuthCubitFactory {
  static DoctorAuthCubit create() {
    final api = ApiService();
    final repo = DoctorAuthRepositoryImpl(api);
    return DoctorAuthCubit(
      DoctorLoginUseCase(repo),
      DoctorRegisterUseCase(repo),
      DoctorVerifyEmailUseCase(repo),
      DoctorForgotPasswordUseCase(repo),
      DoctorResetPasswordUseCase(repo),
      DoctorLogoutUseCase(repo),
      DoctorChangePasswordUseCase(repo),
    );
  }
}
