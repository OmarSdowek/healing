import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/doctor_home_repository_impl.dart';
import '../../domain/usecases/get_doctor_dashboard_usecase.dart';
import 'doctor_home_cubit.dart';

class DoctorHomeCubitFactory {
  static DoctorHomeCubit create() {
    final apiService = ApiService();
    final repository = DoctorHomeRepositoryImpl(apiService);
    final getDashboardUseCase = GetDoctorDashboardUseCase(repository);

    return DoctorHomeCubit(getDashboardUseCase);
  }
}
