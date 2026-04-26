import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/doctor_profile_repository_impl.dart';
import '../../domain/usecases/get_doctor_profile_usecase.dart';
import '../../domain/usecases/update_doctor_profile_usecase.dart';
import 'doctor_profile_cubit.dart';

class DoctorProfileCubitFactory {
  static DoctorProfileCubit create() {
    final apiService = ApiService();
    final repository = DoctorProfileRepositoryImpl(apiService);
    final getProfileUseCase = GetDoctorProfileUseCase(repository);
    final updateProfileUseCase = UpdateDoctorProfileUseCase(repository);

    return DoctorProfileCubit(getProfileUseCase, updateProfileUseCase);
  }
}
