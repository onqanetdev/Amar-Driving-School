

class InstructorStudentAddModel {
  final int status;
  final bool success;
  final String message;
  final AddStudentDetails data;

  InstructorStudentAddModel({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });


  factory InstructorStudentAddModel.fromJson(Map<String, dynamic> json) {
    return InstructorStudentAddModel(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      data: AddStudentDetails.fromJson(json['data']),
    );
  }

}

class AddStudentDetails {
  final int loginId;
  final String name;
  final dynamic surname;
  final String email;
  final String phone;
  final String assignHour;
  final String regDate;
  final String startdate;
  final String amount;
  final String instructureId;
  final String paymentStatus;
  final int role;
  final int status;

  AddStudentDetails({
    required this.loginId,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    required this.assignHour,
    required this.regDate,
    required this.startdate,
    required this.amount,
    required this.instructureId,
    required this.paymentStatus,
    required this.role,
    required this.status,
  });

  factory AddStudentDetails.fromJson(Map<String, dynamic> json) {
    return AddStudentDetails(
      loginId: json['login_id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      phone: json['phone'],
      assignHour: json['assign_hour'],
      regDate: json['reg_date'],
      startdate: json['startdate'],
      amount: json['amount'],
      instructureId: json['instructure_id'],
      paymentStatus: json['payment_status'],
      role: json['role'],
      status: json['status'],
    );
  }

}

