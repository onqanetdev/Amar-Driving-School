
class InstructorStudentUpdateModel {
  final int status;
  final bool success;
  final String message;
  final InstructorStudentUpdateData data;

  InstructorStudentUpdateModel({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorStudentUpdateModel.fromJson(
      Map<String, dynamic> json) {
    return InstructorStudentUpdateModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: InstructorStudentUpdateData.fromJson(
        json['data'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "success": success,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class InstructorStudentUpdateData {
  final String? userId;
  final String? loginId;
  final String? regDate;
  final String? name;
  final String? age;
  final String? surname;
  final String? email;
  final String? phone;
  final String? licenseNo;
  final String? carNo;
  final String? assignHour;
  final String? startdate;
  final String? pickupLocation;
  final String? dropLocation;
  final String? profilePicture;
  final String? password;
  final String? instructureId;
  final String? packageId;
  final String? givenHour;
  final String? role;
  final String? trainingStatus;
  final String? result;
  final String? paymentStatus;
  final String? comments;
  final String? amount;
  final String? delStatus;
  final String? status;

  InstructorStudentUpdateData({
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

  factory InstructorStudentUpdateData.fromJson(
      Map<String, dynamic> json) {
    return InstructorStudentUpdateData(
      userId: json['user_id']?.toString(),
      loginId: json['login_id']?.toString(),
      regDate: json['reg_date']?.toString(),
      name: json['name']?.toString(),
      age: json['age']?.toString(),
      surname: json['surname']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      licenseNo: json['license_no']?.toString(),
      carNo: json['car_no']?.toString(),
      assignHour: json['assign_hour']?.toString(),
      startdate: json['startdate']?.toString(),
      pickupLocation: json['pickup_location']?.toString(),
      dropLocation: json['drop_location']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      password: json['password']?.toString(),
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

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "login_id": loginId,
      "reg_date": regDate,
      "name": name,
      "age": age,
      "surname": surname,
      "email": email,
      "phone": phone,
      "license_no": licenseNo,
      "car_no": carNo,
      "assign_hour": assignHour,
      "startdate": startdate,
      "pickup_location": pickupLocation,
      "drop_location": dropLocation,
      "profile_picture": profilePicture,
      "password": password,
      "instructure_id": instructureId,
      "package_id": packageId,
      "given_hour": givenHour,
      "role": role,
      "training_status": trainingStatus,
      "result": result,
      "payment_status": paymentStatus,
      "comments": comments,
      "amount": amount,
      "del_status": delStatus,
      "status": status,
    };
  }
}