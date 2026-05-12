class CreateMedicalRecordRequest {
  final int patientId;
  final int doctorId;
  final int? appointmentId;
  final String visitDate;
  final String chiefComplaint;
  final String diagnosis;
  final String? icdCode;
  final String? clinicalNotes;
  final String? treatmentPlan;
  final String? followUpDate;
  final bool isConfidential;

  CreateMedicalRecordRequest({
    required this.patientId,
    required this.doctorId,
    this.appointmentId,
    required this.visitDate,
    required this.chiefComplaint,
    required this.diagnosis,
    this.icdCode,
    this.clinicalNotes,
    this.treatmentPlan,
    this.followUpDate,
    this.isConfidential = false,
  });

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'doctorId': doctorId,
        if (appointmentId != null) 'appointmentId': appointmentId,
        'visitDate': visitDate,
        'chiefComplaint': chiefComplaint,
        'diagnosis': diagnosis,
        if (icdCode != null) 'icdCode': icdCode,
        if (clinicalNotes != null) 'clinicalNotes': clinicalNotes,
        if (treatmentPlan != null) 'treatmentPlan': treatmentPlan,
        if (followUpDate != null) 'followUpDate': followUpDate,
        'isConfidential': isConfidential,
      };
}

class AddPrescriptionRequest {
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String? instructions;
  final bool isControlledSubstance;
  final String expiresAt;

  AddPrescriptionRequest({
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.instructions,
    this.isControlledSubstance = false,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
        'medicationName': medicationName,
        'dosage': dosage,
        'frequency': frequency,
        'durationDays': durationDays,
        if (instructions != null) 'instructions': instructions,
        'isControlledSubstance': isControlledSubstance,
        'expiresAt': expiresAt,
      };
}

class AddVitalsRequest {
  final double? temperature;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final int? heartRate;
  final int? respiratoryRate;
  final double? oxygenSaturation;
  final double? weight;
  final double? height;
  final String? recordedBy;

  AddVitalsRequest({
    this.temperature,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.respiratoryRate,
    this.oxygenSaturation,
    this.weight,
    this.height,
    this.recordedBy,
  });

  Map<String, dynamic> toJson() => {
        if (temperature != null) 'temperature': temperature,
        if (bloodPressureSystolic != null)
          'bloodPressureSystolic': bloodPressureSystolic,
        if (bloodPressureDiastolic != null)
          'bloodPressureDiastolic': bloodPressureDiastolic,
        if (heartRate != null) 'heartRate': heartRate,
        if (respiratoryRate != null) 'respiratoryRate': respiratoryRate,
        if (oxygenSaturation != null) 'oxygenSaturation': oxygenSaturation,
        if (weight != null) 'weight': weight,
        if (height != null) 'height': height,
        if (recordedBy != null) 'recordedBy': recordedBy,
      };
}
