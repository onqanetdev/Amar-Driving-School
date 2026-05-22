
class InstructorLessonDeleteModel {

  final int status;
  final bool success;
  final String message;

  InstructorLessonDeleteModel({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorLessonDeleteModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorLessonDeleteModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],
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