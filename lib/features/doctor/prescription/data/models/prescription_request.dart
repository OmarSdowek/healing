class PrescriptionRequest {
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String? instructions;
  final bool isControlledSubstance;
  final String? expiresAt;

  PrescriptionRequest({
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.instructions,
    this.isControlledSubstance = false,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
    "medicationName": medicationName,
    "dosage": dosage,
    "frequency": frequency,
    "durationDays": durationDays,
    if (instructions != null) "instructions": instructions,
    "isControlledSubstance": isControlledSubstance,
    if (expiresAt != null) "expiresAt": expiresAt,
  };
}
