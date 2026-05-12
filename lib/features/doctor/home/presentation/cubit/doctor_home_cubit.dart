import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../../domain/usecases/get_all_doctor_appointments_usecase.dart';
import '../../domain/usecases/get_doctor_dashboard_usecase.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  final GetDoctorDashboardUseCase _getDashboardUseCase;
  final GetAllDoctorAppointmentsUseCase _getAllAppointmentsUseCase;

  DoctorHomeCubit(
    this._getDashboardUseCase,
    this._getAllAppointmentsUseCase,
  ) : super(const DoctorHomeInitial());

  Future<void> loadDashboard() async {
    if (isClosed) return;
    emit(const DoctorHomeLoading());

    final result = await _getDashboardUseCase(null);

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (dashboard) => emit(DoctorHomeLoaded(dashboard)),
    );
  }

  Future<void> refreshDashboard() async {
    if (isClosed) return;
    final result = await _getDashboardUseCase(null);

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (dashboard) => emit(DoctorHomeLoaded(dashboard)),
    );
  }

  Future<void> loadAllAppointments() async {
    if (isClosed) return;
    emit(const DoctorAllAppointmentsLoading());

    final result = await _getAllAppointmentsUseCase(null);

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (appointments) => emit(DoctorAllAppointmentsLoaded(appointments)),
    );
  }

  Future<void> loadTodayAppointments() async {
    if (isClosed) return;
    emit(const DoctorAllAppointmentsLoading());

    // Fetch all days of current + next month
    final result = await _getAllAppointmentsUseCase(null);

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorHomeError(failure.massage)),
      (appointments) => emit(DoctorAllAppointmentsLoaded(appointments)),
    );
  }
}
