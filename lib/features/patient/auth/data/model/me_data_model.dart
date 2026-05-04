class MeDataModel {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String? doctorId;
  final String? patientId;

  MeDataModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    required this.doctorId,
    required this.patientId,
  });

  factory MeDataModel.fromJson(Map<String, dynamic> json) {
    print("🔥 MeDataModel.fromJson called with: $json");
    
    try {
      final model = MeDataModel(
        id: json["id"]?.toString() ?? "",
        email: json["email"]?.toString() ?? "",
        fullName: json["fullName"]?.toString() ?? "",
        roles: json["roles"] != null 
            ? List<String>.from(json["roles"]) 
            : [],
        doctorId: json["doctorId"]?.toString(),
        patientId: json["patientId"]?.toString(),
      );
      
      print("✅ MeDataModel parsed: id=${model.id}, name=${model.fullName}");
      return model;
    } catch (e, stackTrace) {
      print("❌ Error parsing MeDataModel: $e");
      print("❌ StackTrace: $stackTrace");
      rethrow;
    }
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "fullName": fullName,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "doctorId": doctorId,
    "patientId": patientId,
  };
}
