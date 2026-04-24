import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/features/doctor/auth/data/models/doctor_login_request.dart';
import 'package:healing/features/doctor/auth/domin/repo/doctor_auth_repo.dart';
import 'package:healing/features/doctor/auth/domin/use_case/doctor_login_use_case.dart';
import 'package:healing/features/doctor/auth/domin/use_case/doctor_logout_use_case.dart';

part 'doctor_auth_state.dart';

class DoctorAuthCubit extends Cubit<DoctorAuthState> {
  final DoctorLoginUseCase _loginUseCase;
  final DoctorLogoutUseCase _logoutUseCase;
  final DoctorAuthRepo _repo;

  DoctorAuthCubit(this._loginUseCase, this._logoutUseCase, this._repo)
    : super(DoctorAuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(DoctorAuthLoading());
    final result = await _loginUseCase(
      DoctorLoginRequest(email: email, password: password),
    );
    result.fold(
      (failure) => emit(DoctorAuthError(failure.massage)),
      (auth) => emit(DoctorAuthSuccess(auth.user.doctorId ?? "")),
    );
  }

  Future<void> forgotPassword(String email) async {
    emit(DoctorAuthLoading());
    final result = await _repo.forgotPassword(email);
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(DoctorForgotPasswordSent()),
    );
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    emit(DoctorAuthLoading());
    final result = await _repo.resetPassword(
      token: token,
      newPassword: newPassword,
    );
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(DoctorPasswordResetSuccess()),
    );
  }

  Future<void> logout() async {
    emit(DoctorAuthLoading());
    final result = await _logoutUseCase();
    result.fold(
      (failure) => emit(DoctorAuthError(failure.massage)),
      (_) => emit(DoctorAuthLoggedOut()),
    );
  }
}
