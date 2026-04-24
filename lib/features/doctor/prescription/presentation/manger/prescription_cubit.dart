import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_model.dart';
import 'package:healing/features/doctor/prescription/data/models/prescription_request.dart';
import 'package:healing/features/doctor/prescription/domin/use_cases/add_prescription_use_case.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final AddPrescriptionUseCase _addUseCase;

  PrescriptionCubit(this._addUseCase) : super(PrescriptionInitial());

  Future<void> addPrescription({
    required int medicalRecordId,
    required String medicationName,
    required String dosage,
    required String frequency,
    required int durationDays,
    String? instructions,
  }) async {
    emit(PrescriptionLoading());
    final result = await _addUseCase(
      AddPrescriptionParams(
        medicalRecordId: medicalRecordId,
        request: PrescriptionRequest(
          medicationName: medicationName,
          dosage: dosage,
          frequency: frequency,
          durationDays: durationDays,
          instructions: instructions,
        ),
      ),
    );
    result.fold(
      (f) => emit(PrescriptionError(f.massage)),
      (prescription) => emit(PrescriptionSuccess(prescription)),
    );
  }
}
