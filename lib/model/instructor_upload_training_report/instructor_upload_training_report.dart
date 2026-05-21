
class InstructorUploadTrainingReport {

  final int status;
  final bool success;
  final String message;

  InstructorUploadTrainingReport({

    required this.status,

    required this.success,

    required this.message,
  });

  factory InstructorUploadTrainingReport.fromJson(
      Map<String, dynamic> json) {

    return InstructorUploadTrainingReport(

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