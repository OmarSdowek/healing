import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../features/patient/medical_report/domin/entity/prescription_entity.dart';
import '../../../domin/use_cases/download_prescription_pdf_use_case.dart';
import '../../../domin/use_cases/get_prescriptions_use_case.dart';

part 'prescription_state.dart';

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final GetPrescriptionsUseCase _getPrescriptionsUseCase;
  final DownloadPrescriptionPdfUseCase _downloadPdfUseCase;

  PrescriptionCubit(
    this._getPrescriptionsUseCase,
    this._downloadPdfUseCase,
  ) : super(PrescriptionInitial());

  Future<void> loadPrescriptions(int patientId) async {
    if (isClosed) return;
    emit(PrescriptionLoading());

    final result = await _getPrescriptionsUseCase(patientId);

    if (isClosed) return;
    result.fold(
      (failure) => emit(PrescriptionError(failure.massage)),
      (prescriptions) => emit(PrescriptionLoaded(prescriptions)),
    );
  }

  Future<void> downloadPdf({
    required int patientId,
    required String prescriptionId,
  }) async {
    if (isClosed) return;

    // Keep the current list visible while downloading
    final currentList = _currentPrescriptions();
    emit(PrescriptionPdfDownloading(currentList));

    final result = await _downloadPdfUseCase(
      patientId: patientId,
      prescriptionId: prescriptionId,
    );

    if (isClosed) return;
    result.fold(
      (failure) => emit(PrescriptionPdfError(
        prescriptions: currentList,
        message: failure.massage,
      )),
      (filePath) => emit(PrescriptionPdfDownloaded(
        prescriptions: currentList,
        filePath: filePath,
      )),
    );
  }

  List<PrescriptionEntity> _currentPrescriptions() {
    final s = state;
    if (s is PrescriptionLoaded) return s.prescriptions;
    if (s is PrescriptionPdfDownloading) return s.prescriptions;
    if (s is PrescriptionPdfDownloaded) return s.prescriptions;
    if (s is PrescriptionPdfError) return s.prescriptions;
    return [];
  }
}
