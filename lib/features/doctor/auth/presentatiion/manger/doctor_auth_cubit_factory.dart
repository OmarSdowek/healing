import 'package:healing/core/network/api_service.dart';
import 'package:healing/features/doctor/auth/data/repo/doctor_auth_repo_impl.dart';
import 'package:healing/features/doctor/auth/domin/use_case/doctor_login_use_case.dart';
import 'package:healing/features/doctor/auth/domin/use_case/doctor_logout_use_case.dart';
import 'doctor_auth_cubit.dart';

class DoctorAuthCubitFactory {
  static DoctorAuthCubit create() {
    final repo = DoctorAuthRepoImpl(ApiService());
    return DoctorAuthCubit(
      DoctorLoginUseCase(repo),
      DoctorLogoutUseCase(repo),
      repo,
    );
  }
}
