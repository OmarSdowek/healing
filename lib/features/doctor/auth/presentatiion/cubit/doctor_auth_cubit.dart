import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/doctor_login_request.dart';
import '../../data/models/doctor_register_request.dart';
import '../../domain/usecases/doctor_change_password_usecase.dart';
import '../../domain/usecases/doctor_forgot_password_usecase.dart';
import '../../domain/usecases/doctor_login_usecase.dart';
import '../../domain/usecases/doctor_logout_usecase.dart';
import '../../domain/usecases/doctor_register_usecase.dart';
import '../../domain/usecases/doctor_reset_password_usecase.dart';
import '../../domain/usecases/doctor_verify_email_usecase.dart';

part 'doctor_auth_state.dart';

class DoctorAuthCubit extends Cubit<DoctorAuthState> {
  final DoctorLoginUseCase _loginUseCase;
  final DoctorRegisterUseCase _registerUseCase;
  final DoctorVerifyEmailUseCase _verifyEmailUseCase;
  final DoctorForgotPasswordUseCase _forgotPasswordUseCase;
  final DoctorResetPasswordUseCase _resetPasswordUseCase;
  final DoctorLogoutUseCase _logoutUseCase;
  final DoctorChangePasswordUseCase _changePasswordUseCase;

  DoctorAuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._verifyEmailUseCase,
    this._forgotPasswordUseCase,
    this._resetPasswordUseCase,
    this._logoutUseCase,
    this._changePasswordUseCase,
  ) : super(const DoctorAuthInitial());

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const DoctorAuthLoading());
    final result = await _loginUseCase(
      DoctorLoginRequest(email: email, password: password),
    );
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (auth) => emit(DoctorLoginSuccess(auth.user.doctorId ?? '')),
    );
  }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<void> register(DoctorRegisterRequest request) async {
    emit(const DoctorAuthLoading());
    final result = await _registerUseCase(request);
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (auth) {
        final token = auth.emailVerificationToken ?? '';
        if (token.isEmpty) {
          emit(const DoctorAuthError('Verification token not received'));
          return;
        }
        emit(DoctorRegisterSuccess(
          email: request.email,
          emailVerificationToken: token,
        ));
      },
    );
  }

  // ── Verify Email ──────────────────────────────────────────────────────────
  Future<void> verifyEmail(String token) async {
    if (token.isEmpty) {
      emit(const DoctorAuthError('Invalid verification token'));
      return;
    }
    emit(const DoctorAuthLoading());
    final result = await _verifyEmailUseCase(token);
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(const DoctorEmailVerifiedSuccess()),
    );
  }

  // ── Forgot Password ───────────────────────────────────────────────────────
  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      emit(const DoctorAuthError('Email cannot be empty'));
      return;
    }
    emit(const DoctorAuthLoading());
    final result = await _forgotPasswordUseCase(email);
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(const DoctorForgotPasswordSent()),
    );
  }

  // ── Reset Password ────────────────────────────────────────────────────────
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (token.isEmpty || newPassword.isEmpty) {
      emit(const DoctorAuthError('Invalid reset data'));
      return;
    }
    emit(const DoctorAuthLoading());
    final result = await _resetPasswordUseCase(
      DoctorResetPasswordParams(token: token, newPassword: newPassword),
    );
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(const DoctorPasswordResetSuccess()),
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    emit(const DoctorAuthLoading());
    final result = await _logoutUseCase(null);
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(const DoctorLogoutSuccess()),
    );
  }

  // ── Change Password ───────────────────────────────────────────────────────
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(const DoctorAuthLoading());
    final result = await _changePasswordUseCase(
      DoctorChangePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
    result.fold(
      (f) => emit(DoctorAuthError(f.massage)),
      (_) => emit(const DoctorPasswordChanged()),
    );
  }
}
