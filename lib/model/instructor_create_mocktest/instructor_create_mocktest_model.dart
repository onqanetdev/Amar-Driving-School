

class InstructorCreateMocktestModel {

  final int status;
  final bool success;
  final String message;

  InstructorCreateMocktestModel({

    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorCreateMocktestModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorCreateMocktestModel(

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