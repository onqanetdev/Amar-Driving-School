
class InstructorRegisterModel {
  final int status;
  final bool success;
  final String message;
  final InstructorData data;

  InstructorRegisterModel({
    required this.status,
    required this.success,
    required this.message,
    required this.data
});

  factory InstructorRegisterModel.fromJson(Map<String, dynamic> json) {
    return InstructorRegisterModel(
    status: json['status'],
    success: json['success'],
     message: json['message'],
        data: InstructorData.fromJson(json['data'])
  );
  }
}


class InstructorData {
  final int login_id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final int instructure_id;
  final int role;
  final int status;

  InstructorData({
   required this.login_id,
  required this.name,
  required this.email,
  required this.phone,
  required this.password,
  required this.instructure_id,
  required this.role,
  required this.status
});

  factory InstructorData.fromJson(Map<String, dynamic> json) {
    return InstructorData(
        login_id: json['login_id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        instructure_id: json['instructure_id'],
        role: json['role'],
        status: json['status']
    );
  }
}