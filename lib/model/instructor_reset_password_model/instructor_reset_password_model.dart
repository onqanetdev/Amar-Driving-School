
class InstructorResetPasswordModel {

  final int status;
  final bool success;
  final String message;

  InstructorResetPasswordModel({

    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorResetPasswordModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return InstructorResetPasswordModel(

      status: json['status'] ?? 0,

      success: json['success'] ?? false,

      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,
    };
  }
}