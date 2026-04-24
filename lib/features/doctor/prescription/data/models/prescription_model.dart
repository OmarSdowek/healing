class PrescriptionModel {
  final int id;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String? instructions;
  final bool isControlledSubstance;
  final String? expiresAt;
  final String status;

  PrescriptionModel({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    this.instructions,
    required this.isControlledSubstance,
    this.expiresAt,
    required this.status,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionModel(
        id: json["id"] ?? 0,
        medicationName: json["medicationName"] ?? "",
        dosage: json["dosage"] ?? "",
        frequency: json["frequency"] ?? "",
        durationDays: json["durationDays"] ?? 0,
        instructions: json["instructions"],
        isControlledSubstance: json["isControlledSubstance"] ?? false,
        expiresAt: json["expiresAt"],
        status: json["status"] ?? "",
      );
}
