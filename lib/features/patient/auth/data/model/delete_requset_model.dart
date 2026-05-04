

class DeleteRequsetModel {
  final String userId;

  DeleteRequsetModel({required this.userId});


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}