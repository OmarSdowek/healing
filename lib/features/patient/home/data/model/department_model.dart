class DepartmentModel {
  final int id;
  final String name;
  final String? phoneExtension;

  DepartmentModel({
    required this.id,
    required this.name,
    this.phoneExtension,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneExtension: json['phoneExtension'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneExtension': phoneExtension,
    };
  }
}
