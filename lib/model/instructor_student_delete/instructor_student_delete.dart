
class InstructorStudentDeleteModel {
  final int status;
  final bool success;
  final String message;

  InstructorStudentDeleteModel({
    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorStudentDeleteModel.fromJson(Map<String, dynamic> json) {
    return InstructorStudentDeleteModel(
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