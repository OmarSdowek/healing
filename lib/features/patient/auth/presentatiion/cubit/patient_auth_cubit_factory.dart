import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/patient_auth_repository_impl.dart';
import '../../domin/use_case/patient_login_usecase.dart';
import 'patient_auth_cubit.dart';

class PatientAuthCubitFactory {
  static PatientAuthCubit create() {
    final apiService = ApiService();
    final repository = PatientAuthRepositoryImpl(apiService);
    final loginUseCase = PatientLoginUseCase(repository);

    return PatientAuthCubit(loginUseCase);
  }
}
