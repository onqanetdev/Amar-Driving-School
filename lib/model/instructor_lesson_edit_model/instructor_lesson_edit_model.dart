

class InstructorLessonEdit {

  final int status;
  final bool success;
  final String message;

  InstructorLessonEdit({

    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorLessonEdit.fromJson(
      Map<String, dynamic> json) {

    return InstructorLessonEdit(

      status: json['status'],

      success: json['success'],

      message: json['message'],
    );
  }
}