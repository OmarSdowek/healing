import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/features/patient/auth/data/model/delete_requset_model.dart';
import 'package:healing/features/patient/auth/data/model/reset_password_request_model.dart';
import 'package:healing/features/patient/auth/domin/use_case/patient_log_out_use_case.dart';
import '../../data/model/forget_request_model.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/me_data_model.dart';
import '../../data/model/register_request_model.dart';
import '../../domin/use_case/delete_acount_use_case.dart';
import '../../domin/use_case/email_verify.dart';
import '../../domin/use_case/login_use_case.dart';
import '../../domin/use_case/me_data_use_case.dart';
import '../../domin/use_case/patient_forget_password.dart';
import '../../domin/use_case/register_use_case.dart';
import '../../domin/use_case/reset_password_use_case.dart';
part 'patient_auth_state.dart';

class PatientAuthCubit extends Cubit<PatientAuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyEmailUseCaseImpl verifyEmailUseCase;
  final PatientForgetPassword forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final PatientLogOutUseCase logoutUseCase;
  final DeleteAcountUseCase deleteAcountUseCase;
  final MeDataUseCase meDataUseCase;


  PatientAuthCubit(
    this.registerUseCase,
    this.loginUseCase,
    this.verifyEmailUseCase,
    this.forgotPasswordUseCase,
    this.resetPasswordUseCase,
    this.logoutUseCase,
    this.deleteAcountUseCase,
      this.meDataUseCase,
  ) : super(PatientAuthInitial());

  // ================= REGISTER =================
  Future<void> register(RegisterRequestModel request) async {
    emit(PatientAuthLoading());

    final result = await registerUseCase(request);

    result.fold((failure) => emit(PatientAuthError(failure.massage)), (auth) {
      final token = auth.emailVerificationToken;

      if (token == null || token.isEmpty) {
        emit(PatientAuthError('Email verification token not received'));
        return;
      }

      emit(
        PatientRegisterSuccess(
          email: auth.user.email,
          emailVerificationToken: token,
        ),
      );
    });
  }

  // ================= LOGIN =================
  Future<void> login({required LoginRequestModel request}) async {
    emit(PatientAuthLoading());

    final result = await loginUseCase(request);

    result.fold(
      (failure) => emit(PatientAuthError(failure.massage)),
      (auth) => emit(PatientLoginSuccess(auth.user.id)),
    );
  }

  // ================= VERIFY EMAIL =================
  Future<void> verifyEmail(String token) async {
    if (token.isEmpty) {
      emit(PatientAuthError("Invalid verification token"));
      return;
    }

    emit(PatientAuthLoading());

    final result = await verifyEmailUseCase(token);

    result.fold(
      (failure) => emit(PatientAuthError(failure.massage)),
      (_) => emit(PatientEmailVerifiedSuccess()),
    );
  }

  // ================= FORGOT PASSWORD =================
  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      emit(PatientAuthError("Email cannot be empty"));
      return;
    }

    emit(PatientAuthLoading());

    final result = await forgotPasswordUseCase(
      ForgetRequestModel(email: email),
    );

    result.fold(
      (failure) => emit(PatientAuthError(failure.massage)),
      (_) => emit(PatientForgotPasswordSent()),
    );
  }

  // ================= RESET PASSWORD =================
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (token.isEmpty || newPassword.isEmpty) {
      emit(PatientAuthError("Invalid reset data"));
      return;
    }

    emit(PatientAuthLoading());

    final result = await resetPasswordUseCase(
      ResetPasswordRequestModel(token: token, newPassword: newPassword),
    );

    result.fold(
      (failure) => emit(PatientAuthError(failure.massage)),
      (_) => emit(PatientPasswordResetSuccess()),
    );
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    print("🔥 PatientAuthCubit: logout() called");
    emit(PatientAuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        print("❌ Logout failed: ${failure.massage}");
        emit(PatientAuthError(failure.massage));
      },
      (_) {
        print("✅ Logout successful");
        emit(PatientLoggedOut());
      },
    );
  }

  // ================= Delete =================

  Future<void> deleteAccount(String userId) async {
    print("🔥 PatientAuthCubit: deleteAccount() called for user: $userId");
    emit(PatientAuthLoading());

    final result = await deleteAcountUseCase(DeleteRequsetModel(userId: userId));

    result.fold(
      (failure) {
        print("❌ Delete account failed: ${failure.massage}");
        emit(PatientAuthError(failure.massage));
      },
      (_) {
        print("✅ Account deleted successfully");
        emit(PatientAccountDeletedSuccess());
      },
    );
  }


  // ================= Me =================

  Future<void> meData() async {
    print("🔥 PatientAuthCubit: meData() called");
    emit(PatientAuthLoading());
    print("🔥 PatientAuthCubit: PatientAuthLoading emitted");
    
    try {
      final result = await meDataUseCase();
      print("🔥 PatientAuthCubit: meDataUseCase completed");
      
      result.fold(
        (failure) {
          print("❌ PatientAuthCubit: Error - ${failure.massage}");
          emit(PatientAuthError(failure.massage));
        },
        (data) {
          print("✅ PatientAuthCubit: Success - ${data.fullName}");
          emit(PatientDataSuccess(data));
        },
      );
    } catch (e, stackTrace) {
      print("❌ PatientAuthCubit: Unexpected error - $e");
      print("❌ StackTrace: $stackTrace");
      emit(PatientAuthError("Failed to load profile: $e"));
    }
  }

}
