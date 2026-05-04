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
    emit(MedicalReportLoading());
    final result = await getReportsUseCase(patientId);
    result.fold(
      (f) {
        print("⚠️ Medical reports API unavailable: ${f.massage}");
        emit(MedicalReportsLoaded([])); // empty — no mock data
      },
      (reports) => emit(MedicalReportsLoaded(reports)),
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
    emit(MedicalReportLoading());
    // Try active prescriptions first
    final activeResult = await getActivePrescriptionsUseCase(patientId);
    activeResult.fold(
      (f) async {
        print("⚠️ Active prescriptions failed: ${f.massage} — trying all");
        final allResult = await getPrescriptionsUseCase(patientId);
        allResult.fold(
          (f2) {
            print("⚠️ All prescriptions failed — showing empty state");
            emit(PrescriptionsLoaded([])); // empty — no mock data
          },
          (list) => emit(PrescriptionsLoaded(list)),
        );
      },
      (list) => emit(PrescriptionsLoaded(list)),
    );
  }

  // loadPrescriptionDetail removed — no endpoint available in API
}
