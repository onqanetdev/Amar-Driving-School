
class InstructorContactUsFormModel {

  final int status;
  final bool success;
  final String message;

  InstructorContactUsFormModel({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorContactUsFormModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorContactUsFormModel(

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
