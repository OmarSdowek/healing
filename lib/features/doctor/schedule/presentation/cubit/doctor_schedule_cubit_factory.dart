import 'package:healing/core/network/api_service.dart';
import '../../data/repositories/doctor_schedule_repository_impl.dart';
import '../../domain/usecases/get_doctor_schedules_usecase.dart';
import '../../domain/usecases/update_doctor_schedule_usecase.dart';
import 'doctor_schedule_cubit.dart';

class DoctorScheduleCubitFactory {
  static DoctorScheduleCubit create() {
    final apiService = ApiService();
    final repository = DoctorScheduleRepositoryImpl(apiService);
    final getSchedulesUseCase = GetDoctorSchedulesUseCase(repository);
    final updateScheduleUseCase = UpdateDoctorScheduleUseCase(repository);

    return DoctorScheduleCubit(getSchedulesUseCase, updateScheduleUseCase);
  }
}
