

class InstructorMocktestReviewModel {

  final int status;
  final bool success;
  final String message;

  InstructorMocktestReviewModel({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorMocktestReviewModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorMocktestReviewModel(

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