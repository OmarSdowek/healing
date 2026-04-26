import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/patient_auth_response.dart';
import '../../data/models/patient_login_request.dart';
import '../../domin/use_case/patient_login_usecase.dart';

part 'patient_auth_state.dart';

class PatientAuthCubit extends Cubit<PatientAuthState> {
  final PatientLoginUseCase _loginUseCase;

  PatientAuthCubit(this._loginUseCase) : super(const PatientAuthInitial());

  Future<void> login(String email, String password) async {
    emit(const PatientAuthLoading());

    final request = PatientLoginRequest(email: email, password: password);
    final result = await _loginUseCase(request);

    result.fold(
      (failure) => emit(PatientAuthError(failure.massage)),
      (auth) => emit(PatientAuthSuccess(auth)),
    );
  }
}
