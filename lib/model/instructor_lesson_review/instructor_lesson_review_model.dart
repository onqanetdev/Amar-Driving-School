
class InstructorLessonReviewModel {

  final int status;
  final bool success;
  final String message;

  InstructorLessonReviewModel({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorLessonReviewModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorLessonReviewModel(

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