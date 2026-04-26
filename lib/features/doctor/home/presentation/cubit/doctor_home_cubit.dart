import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../../domain/usecases/get_doctor_dashboard_usecase.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  final GetDoctorDashboardUseCase _getDashboardUseCase;

  DoctorHomeCubit(this._getDashboardUseCase) : super(const DoctorHomeInitial());

  Future<void> loadDashboard() async {
    emit(const DoctorHomeLoading());

    final result = await _getDashboardUseCase(null);

    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (dashboard) => emit(DoctorHomeLoaded(dashboard)),
    );
  }

  Future<void> refreshDashboard() async {
    final result = await _getDashboardUseCase(null);

    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (dashboard) => emit(DoctorHomeLoaded(dashboard)),
    );
  }
}
