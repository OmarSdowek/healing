import '../../../../../core/utils/appointment_date_helper.dart';

/// Encapsulates patient summary data passed between screens via route args.
/// Single responsibility: parse and hold patient summary from route arguments.
class PatientSummaryArgs {
  final int? recordId;
  final int? patientId;
  final String patientName;
  final int? patientAge;
  final String? patientMrn;
  final String? patientBloodType;
  final String? patientWeight;

  const PatientSummaryArgs({
    this.recordId,
    this.patientId,
    required this.patientName,
    this.patientAge,
    this.patientMrn,
    this.patientBloodType,
    this.patientWeight,
  });

  /// Whether patient details need to be fetched from API.
  /// Only fetch if bloodType is missing (age + MRN come from appointment now).
  bool get needsDetailsFetch =>
      patientId != null && patientBloodType == null;

  /// Parse from route arguments map.
  factory PatientSummaryArgs.fromRouteArgs(Map<String, dynamic>? args) {
    return PatientSummaryArgs(
      recordId: args?['recordId'] as int?,
      patientId: args?['patientId'] as int?,
      patientName: args?['patientName'] as String? ?? 'Patient',
      patientAge: args?['patientAge'] as int?,
      patientMrn: args?['patientMrn'] as String?,
      patientBloodType: args?['patientBloodType'] as String?,
      patientWeight: args?['patientWeight'] as String?,
    );
  }

  /// Returns a copy with updated patient details from API response.
  PatientSummaryArgs copyWithDetails({
    required String fullName,
    required String? mrn,
    required String? bloodType,
    required String? dateOfBirth,
  }) {
    return PatientSummaryArgs(
      recordId: recordId,
      patientId: patientId,
      patientName: fullName.isNotEmpty ? fullName : patientName,
      patientAge: AppointmentDateHelper.calculateAge(dateOfBirth) ?? patientAge,
      patientMrn: mrn ?? patientMrn,
      patientBloodType: bloodType ?? patientBloodType,
      patientWeight: patientWeight,
    );
  }
}
