

import 'dart:convert';

class StudentLoginResModel {
  final int status;
  final bool success;
  final String message;
  final StudentData student;
  StudentLoginResModel({
    required this.status,
    required this.success,
    required this.message,
    required this.student
});

  factory StudentLoginResModel.fromJson(Map<String, dynamic> json) {
    return StudentLoginResModel(
    status: json['status'],
    success: json['success'],
  message: json['message'],
  student: StudentData.fromJson(json['student'])
  );
  }
}

class StudentData {
  String? userId;
  String? loginId;
  String? regDate;
  String? name;
  String? age;
  String? surname;
  String? email;
  String? phone;
  Null? licenseNo;
  Null? carNo;
  String? assignHour;
  Null? startdate;
  Null? pickupLocation;
  Null? dropLocation;
  Null? profilePicture;
  String? instructureId;
  Null? packageId;
  String? givenHour;
  String? role;
  Null? trainingStatus;
  Null? result;
  Null? paymentStatus;
  Null? comments;
  String? amount;
  String? delStatus;
  String? status;

  StudentData({
    this.userId,
        this.loginId,
        this.regDate,
        this.name,
        this.age,
        this.surname,
        this.email,
        this.phone,
        this.licenseNo,
        this.carNo,
        this.assignHour,
        this.startdate,
        this.pickupLocation,
        this.dropLocation,
        this.profilePicture,
        this.instructureId,
        this.packageId,
        this.givenHour,
        this.role,
        this.trainingStatus,
        this.result,
        this.paymentStatus,
        this.comments,
        this.amount,
        this.delStatus,
        this.status
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {

    return StudentData(
      userId: json['user_id'],
      loginId: json['login_id'],
      regDate: json['reg_date'],
      name: json['name'],
      age: json['age'],
      surname: json['surname'],
      email: json['email'],
      phone: json['phone'],
      licenseNo: json['license_no'],
      carNo: json['car_no'],
      assignHour: json['assign_hour'],
      startdate: json['startdate'],
      pickupLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      profilePicture: json['profile_picture'],
      instructureId: json['instructure_id'],
      packageId: json['package_id'],
      givenHour: json['given_hour'],
      role: json['role'],
      trainingStatus: json['training_status'],
      result: json['result'],
      paymentStatus: json['payment_status'],
      comments: json['comments'],
      amount: json['amount'],
      delStatus: json['del_status'],
      status: json['status'],
    );
  }
}