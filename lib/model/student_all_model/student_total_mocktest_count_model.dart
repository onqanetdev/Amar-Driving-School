

class StudentTotalMocktestCountModel {

  final int status;
  final bool success;
  final String message;
  final int data;

  StudentTotalMocktestCountModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentTotalMocktestCountModel.fromJson(
      Map<String, dynamic> json) {

    return StudentTotalMocktestCountModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data,
    };
  }
}