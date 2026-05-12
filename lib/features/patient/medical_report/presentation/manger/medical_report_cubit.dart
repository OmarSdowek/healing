import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/entity/medical_report_entity.dart';
import '../../domin/entity/prescription_entity.dart';
import '../../domin/use_cases/get_reports_use_case.dart';

part 'medical_report_state.dart';

class MedicalReportCubit extends Cubit<MedicalReportState> {
  final GetReportsUseCase getReportsUseCase;
  final GetReportDetailUseCase getReportDetailUseCase;
  final GetPrescriptionsUseCase getPrescriptionsUseCase;
  final GetActivePrescriptionsUseCase getActivePrescriptionsUseCase;

  MedicalReportCubit(
    this.getReportsUseCase,
    this.getReportDetailUseCase,
    this.getPrescriptionsUseCase,
    this.getActivePrescriptionsUseCase,
  ) : super(MedicalReportInitial());

  Future<void> loadReports(int patientId) async {
    if (isClosed) return;
    emit(MedicalReportLoading());
    final result = await getReportsUseCase(patientId);
    if (isClosed) return;
    result.fold(
      (f) {
        print("⚠️ Medical reports API unavailable: ${f.massage}");
        if (!isClosed) emit(MedicalReportsLoaded([]));
      },
      (reports) {
        if (!isClosed) emit(MedicalReportsLoaded(reports));
      },
    );
  }

  Future<void> loadReportDetail(String reportId) async {
    emit(MedicalReportLoading());
    final result = await getReportDetailUseCase(reportId);
    result.fold(
      (f) {
        print("⚠️ Report detail API unavailable: ${f.massage}");
        emit(MedicalReportError(f.massage));
      },
      (detail) => emit(MedicalReportDetailLoaded(detail)),
    );
  }

  Future<void> loadPrescriptions(int patientId) async {
    if (isClosed) return;
    emit(MedicalReportLoading());
    final activeResult = await getActivePrescriptionsUseCase(patientId);
    if (isClosed) return;
    activeResult.fold(
      (f) async {
        print("⚠️ Active prescriptions failed: ${f.massage} — trying all");
        final allResult = await getPrescriptionsUseCase(patientId);
        if (isClosed) return;
        allResult.fold(
          (f2) {
            print("⚠️ All prescriptions failed — showing empty state");
            if (!isClosed) emit(PrescriptionsLoaded([]));
          },
          (list) {
            if (!isClosed) emit(PrescriptionsLoaded(list));
          },
        );
      },
      (list) {
        if (!isClosed) emit(PrescriptionsLoaded(list));
      },
    );
  }

  // loadPrescriptionDetail removed — no endpoint available in API
}
