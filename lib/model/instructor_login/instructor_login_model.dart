
import 'package:flutter/foundation.dart';

// class InstructorLoginModel {
//   final int status;
//   final bool success;
//   final String message;
//   final InstructorDetails instructor;
//
//   InstructorLoginModel({
//     required this.status,
//     required this.success,
//     required this.message,
//     required this.instructor
// });
//
//   factory InstructorLoginModel.fromJson(Map<String, dynamic> json) {
//     return InstructorLoginModel(
//         status: json['status'],
//         success: json['success'],
//         message: json['message'],
//         instructor: InstructorDetails.fromJson(json['instructor'])
//     );
//   }
// }
//
// class InstructorDetails {
//   String? userId;
//   String? loginId;
//   String? regDate;
//   String? name;
//   Null? age;
//   Null? surname;
//   String? email;
//   String? phone;
//   Null? licenseNo;
//   Null? carNo;
//   Null? assignHour;
//   Null? pickupLocation;
//   Null? dropLocation;
//   Null? profilePicture;
//   String? instructureId;
//   Null? packageId;
//   String? givenHour;
//   String? role;
//   Null? trainingStatus;
//   Null? result;
//   Null? paymentStatus;
//   Null? comments;
//   String? amount;
//   String? delStatus;
//   String? status;
//
//   InstructorDetails(
//       {
//         this.userId,
//         this.loginId,
//         this.regDate,
//         this.name,
//         this.age,
//         this.surname,
//         this.email,
//         this.phone,
//         this.licenseNo,
//         this.carNo,
//         this.assignHour,
//         this.pickupLocation,
//         this.dropLocation,
//         this.profilePicture,
//         this.instructureId,
//         this.packageId,
//         this.givenHour,
//         this.role,
//         this.trainingStatus,
//         this.result,
//         this.paymentStatus,
//         this.comments,
//         this.amount,
//         this.delStatus,
//         this.status});
//
//    factory InstructorDetails.fromJson(Map<String, dynamic> json) {
//      return InstructorDetails(
//          userId : json['user_id'],
//          loginId : json['login_id'],
//          regDate : json['reg_date'],
//          name : json['name'],
//          age : json['age'],
//          surname : json['surname'],
//          email : json['email'],
//          phone : json['phone'],
//          licenseNo : json['license_no'],
//          carNo : json['car_no'],
//          assignHour : json['assign_hour'],
//          pickupLocation : json['pickup_location'],
//          dropLocation : json['drop_location'],
//      profilePicture : json['profile_picture'],
//      instructureId : json['instructure_id'],
//      packageId : json['package_id'],
//      givenHour : json['given_hour'],
//      role : json['role'],
//      trainingStatus : json['training_status'],
//      result : json['result'],
//      paymentStatus : json['payment_status'],
//      comments : json['comments'],
//      amount : json['amount'],
//      delStatus : json['del_status'],
//      status : json['status'],
//      );
//   }
// }

class InstructorLoginModel {
  final int status;
  final bool success;
  final String message;
  final InstructorDetails instructor;

  InstructorLoginModel({
    required this.status,
    required this.success,
    required this.message,
    required this.instructor,
  });

  factory InstructorLoginModel.fromJson(Map<String, dynamic> json) {
    return InstructorLoginModel(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      instructor: InstructorDetails.fromJson(json['instructor']),
    );
  }
}

class InstructorDetails {
  String? userId;
  String? loginId;
  String? regDate;
  String? name;
  String? age;
  String? surname;
  String? email;
  String? phone;
  String? licenseNo;
  String? carNo;
  String? assignHour;
  String? startDate;
  String? pickupLocation;
  String? dropLocation;
  String? profilePicture;
  String? instructureId;
  String? packageId;
  String? givenHour;
  String? role;
  String? trainingStatus;
  String? result;
  String? paymentStatus;
  String? comments;
  String? amount;
  String? delStatus;
  String? status;

  InstructorDetails({
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
    this.startDate,
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
    this.status,
  });

  factory InstructorDetails.fromJson(Map<String, dynamic> json) {
    return InstructorDetails(
      userId: json['user_id']?.toString(),
      loginId: json['login_id']?.toString(),
      regDate: json['reg_date'],
      name: json['name'],
      age: json['age']?.toString(),
      surname: json['surname']?.toString(),
      email: json['email'],
      phone: json['phone'],
      licenseNo: json['license_no']?.toString(),
      carNo: json['car_no']?.toString(),
      assignHour: json['assign_hour']?.toString(),
      startDate: json['startdate']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      dropLocation: json['drop_location']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      instructureId: json['instructure_id']?.toString(),
      packageId: json['package_id']?.toString(),
      givenHour: json['given_hour']?.toString(),
      role: json['role']?.toString(),
      trainingStatus: json['training_status']?.toString(),
      result: json['result']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      comments: json['comments']?.toString(),
      amount: json['amount']?.toString(),
      delStatus: json['del_status']?.toString(),
      status: json['status']?.toString(),
    );
  }
}