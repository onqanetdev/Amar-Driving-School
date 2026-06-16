
class InstructorForgotPasswordModel {
  final int? status;
  final bool? success;
  final String? message;
  final InstructorForgotPasswordData? data;

  InstructorForgotPasswordModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory InstructorForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return InstructorForgotPasswordModel(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? InstructorForgotPasswordData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}



class InstructorForgotPasswordData {
  final String? userId;
  final String? loginId;
  final String? regDate;
  final String? name;
  final dynamic age;
  final dynamic surname;
  final String? email;
  final String? phone;
  final dynamic licenseNo;
  final dynamic carNo;
  final dynamic assignHour;
  final dynamic startdate;
  final dynamic pickupLocation;
  final dynamic dropLocation;
  final dynamic profilePicture;
  final String? password;
  final String? instructureId;
  final dynamic packageId;
  final String? givenHour;
  final String? role;
  final dynamic trainingStatus;
  final dynamic result;
  final dynamic paymentStatus;
  final dynamic comments;
  final String? amount;
  final String? delStatus;
  final String? status;

  InstructorForgotPasswordData({
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
    this.password,
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

  factory InstructorForgotPasswordData.fromJson(
      Map<String, dynamic> json) {
    return InstructorForgotPasswordData(
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
      password: json['password'],
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

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'login_id': loginId,
      'reg_date': regDate,
      'name': name,
      'age': age,
      'surname': surname,
      'email': email,
      'phone': phone,
      'license_no': licenseNo,
      'car_no': carNo,
      'assign_hour': assignHour,
      'startdate': startdate,
      'pickup_location': pickupLocation,
      'drop_location': dropLocation,
      'profile_picture': profilePicture,
      'password': password,
      'instructure_id': instructureId,
      'package_id': packageId,
      'given_hour': givenHour,
      'role': role,
      'training_status': trainingStatus,
      'result': result,
      'payment_status': paymentStatus,
      'comments': comments,
      'amount': amount,
      'del_status': delStatus,
      'status': status,
    };
  }
}

