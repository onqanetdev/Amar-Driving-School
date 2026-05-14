

class InstructorCreateLessonModel {

  final int status;
  final bool success;
  final String message;

  InstructorCreateLessonModel({

    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorCreateLessonModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorCreateLessonModel(

      status: json['status'],
      success: json['success'],
      message: json['message'],
    );
  }
}