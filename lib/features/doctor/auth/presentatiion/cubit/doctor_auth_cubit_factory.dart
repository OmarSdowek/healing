import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/doctor_auth_repository_impl.dart';
import '../../domain/usecases/doctor_change_password_usecase.dart';
import '../../domain/usecases/doctor_login_usecase.dart';
import '../../domain/usecases/doctor_logout_usecase.dart';
import 'doctor_auth_cubit.dart';

class DoctorAuthCubitFactory {
  static DoctorAuthCubit create() {
    final apiService = ApiService();
    final repository = DoctorAuthRepositoryImpl(apiService);
    final loginUseCase = DoctorLoginUseCase(repository);
    final logoutUseCase = DoctorLogoutUseCase(repository);
    final changePasswordUseCase = DoctorChangePasswordUseCase(repository);

    return DoctorAuthCubit(loginUseCase, logoutUseCase, changePasswordUseCase);
  }
}
