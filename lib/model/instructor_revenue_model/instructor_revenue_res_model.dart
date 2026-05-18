

class InstructorRevenueResModel {

  final int status;
  final bool success;
  final String message;
  final int totalRevenue;

  InstructorRevenueResModel({

    required this.status,
    required this.success,
    required this.message,
    required this.totalRevenue,
  });

  factory InstructorRevenueResModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorRevenueResModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      totalRevenue: json['total_revenue'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'total_revenue': totalRevenue,
    };
  }
}