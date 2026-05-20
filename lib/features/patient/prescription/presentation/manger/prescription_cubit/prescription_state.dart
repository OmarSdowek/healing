part of 'prescription_cubit.dart';

abstract class PrescriptionState {}

class PrescriptionInitial extends PrescriptionState {}

class PrescriptionLoading extends PrescriptionState {}

class PrescriptionLoaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  PrescriptionLoaded(this.prescriptions);
}

class PrescriptionError extends PrescriptionState {
  final String message;
  PrescriptionError(this.message);
}

// ─── PDF Download States ──────────────────────────────────────────────────────

class PrescriptionPdfDownloading extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  PrescriptionPdfDownloading(this.prescriptions);
}

class PrescriptionPdfDownloaded extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  final String filePath;
  PrescriptionPdfDownloaded({
    required this.prescriptions,
    required this.filePath,
  });
}

class PrescriptionPdfError extends PrescriptionState {
  final List<PrescriptionEntity> prescriptions;
  final String message;
  PrescriptionPdfError({
    required this.prescriptions,
    required this.message,
  });
}
