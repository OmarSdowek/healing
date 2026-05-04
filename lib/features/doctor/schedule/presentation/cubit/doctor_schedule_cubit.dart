import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_schedule_entity.dart';
import '../../domain/usecases/get_doctor_schedules_usecase.dart';
import '../../domain/usecases/update_doctor_schedule_usecase.dart';

part 'doctor_schedule_state.dart';

class DoctorScheduleCubit extends Cubit<DoctorScheduleState> {
  final GetDoctorSchedulesUseCase _getSchedulesUseCase;
  final UpdateDoctorScheduleUseCase _updateScheduleUseCase;

  DoctorScheduleCubit(this._getSchedulesUseCase, this._updateScheduleUseCase)
    : super(const DoctorScheduleInitial());

  Future<void> loadSchedules() async {
    emit(const DoctorScheduleLoading());

    final result = await _getSchedulesUseCase(null);

    result.fold(
      (failure) => emit(DoctorScheduleError(failure.massage)),
      (schedules) => emit(DoctorScheduleLoaded(schedules)),
    );
  }

  Future<void> updateSchedule(
    int scheduleId,
    DoctorScheduleEntity schedule,
  ) async {
    emit(const DoctorScheduleUpdating());

    final result = await _updateScheduleUseCase(
      UpdateDoctorScheduleParams(scheduleId: scheduleId, schedule: schedule),
    );

    result.fold(
      (failure) => emit(DoctorScheduleError(failure.massage)),
      (schedule) => emit(DoctorScheduleUpdated(schedule)),
    );
  }
}
