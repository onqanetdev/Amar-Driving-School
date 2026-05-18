

class InstructorStudentTotalCountModel {

  final int status;
  final bool success;
  final String message;
  final String totalStudent;

  InstructorStudentTotalCountModel({
    required this.status,
    required this.success,
    required this.message,
    required this.totalStudent,
  });

  factory InstructorStudentTotalCountModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorStudentTotalCountModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      totalStudent: json['total_student'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'total_student': totalStudent,
    };
  }
}