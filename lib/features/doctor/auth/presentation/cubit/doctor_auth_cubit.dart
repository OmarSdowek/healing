import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/doctor_login_request.dart';
import '../../domain/usecases/doctor_login_usecase.dart';
import '../../domain/usecases/doctor_logout_usecase.dart';

part 'doctor_auth_state.dart';

class DoctorAuthCubit extends Cubit<DoctorAuthState> {
  final DoctorLoginUseCase _loginUseCase;
  final DoctorLogoutUseCase _logoutUseCase;

  DoctorAuthCubit(this._loginUseCase, this._logoutUseCase)
    : super(const DoctorAuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const DoctorAuthLoading());

    final result = await _loginUseCase(
      DoctorLoginRequest(email: email, password: password),
    );

    result.fold(
      (failure) => emit(DoctorAuthError(failure.massage)),
      (auth) => emit(DoctorAuthSuccess(auth.user.doctorId ?? "")),
    );
  }

  Future<void> logout() async {
    emit(const DoctorAuthLoading());

    final result = await _logoutUseCase(null);

    result.fold(
      (failure) => emit(DoctorAuthError(failure.massage)),
      (_) => emit(const DoctorLogoutSuccess()),
    );
  }
}
