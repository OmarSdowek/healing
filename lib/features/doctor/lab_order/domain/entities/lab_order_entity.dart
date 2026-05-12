class LabTestEntity {
  final String name;
  final String? code;

  const LabTestEntity({required this.name, this.code});
}

class LabOrderEntity {
  final int? id;
  final int? recordId;
  final List<String> tests;
  final String? clinicalIndication;
  final String? priority;
  final String? status;
  final String? createdAt;

  const LabOrderEntity({
    this.id,
    this.recordId,
    required this.tests,
    this.clinicalIndication,
    this.priority,
    this.status,
    this.createdAt,
  });
}
