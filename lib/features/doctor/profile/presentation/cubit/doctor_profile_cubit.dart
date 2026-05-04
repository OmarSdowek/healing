import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/usecases/get_doctor_profile_usecase.dart';
import '../../domain/usecases/update_doctor_profile_usecase.dart';

part 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final GetDoctorProfileUseCase _getProfileUseCase;
  final UpdateDoctorProfileUseCase _updateProfileUseCase;

  DoctorProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
    : super(const DoctorProfileInitial());

  Future<void> getProfile() async {
    emit(const DoctorProfileLoading());

    final result = await _getProfileUseCase(null);

    result.fold(
      (failure) => emit(DoctorProfileError(failure.massage)),
      (profile) => emit(DoctorProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile(DoctorProfileEntity profile) async {
    emit(const DoctorProfileUpdating());

    final result = await _updateProfileUseCase(profile);

    result.fold(
      (failure) => emit(DoctorProfileError(failure.massage)),
      (_) => emit(const DoctorProfileUpdateSuccess()),
    );
  }
}
