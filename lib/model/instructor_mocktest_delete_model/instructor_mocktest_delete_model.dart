
class InstructorMocktestDeleteModel {

  final int status;
  final bool success;
  final String message;

  InstructorMocktestDeleteModel({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorMocktestDeleteModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorMocktestDeleteModel(

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
