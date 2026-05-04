

class ForgetRequestModel {
  final String email;

  ForgetRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email.toString(),
    };
  }
}


