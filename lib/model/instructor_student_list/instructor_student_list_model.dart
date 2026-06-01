

class InstructorStudentListModel {

  final int status;
  final bool success;
  final String message;
  final List<StudentData> data;

  InstructorStudentListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorStudentListModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorStudentListModel(

      status: json['status'],
      success: json['success'],
      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => StudentData.fromJson(e),
      ).toList(),
    );
  }
}

class StudentData {

  final String userId;
  final String loginId;
  final String regDate;
  String name;
  final dynamic age;
  final dynamic surname;
  final String email;
  final String phone;
  final dynamic licenseNo;
  final dynamic carNo;
  final String? assignHour;
  final String? startdate;
  final dynamic pickupLocation;
  final dynamic dropLocation;
  final dynamic profilePicture;
  //final String password;
  final String instructureId;
  final dynamic packageId;
  final String givenHour;
  final String role;
  final dynamic trainingStatus;
  final dynamic result;
  final String? paymentStatus;
  final dynamic comments;
  final String? amount;
  final String delStatus;
  final String status;

  StudentData({

    required this.userId,
    required this.loginId,
    required this.regDate,
    required this.name,
    required this.age,
    required this.surname,
    required this.email,
    required this.phone,
    required this.licenseNo,
    required this.carNo,
    required this.assignHour,
    required this.startdate,
    required this.pickupLocation,
    required this.dropLocation,
    required this.profilePicture,
    //required this.password,
    required this.instructureId,
    required this.packageId,
    required this.givenHour,
    required this.role,
    required this.trainingStatus,
    required this.result,
    required this.paymentStatus,
    required this.comments,
    required this.amount,
    required this.delStatus,
    required this.status,
  });

  factory StudentData.fromJson(
      Map<String, dynamic> json) {

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
      assignHour: json['assign_hour']?.toString(),
      startdate: json['startdate']?.toString(),
      pickupLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      profilePicture: json['profile_picture'],
      //password: json['password'],
      instructureId: json['instructure_id'],
      packageId: json['package_id'],
      givenHour: json['given_hour'],
      role: json['role'],
      trainingStatus: json['training_status'],
      result: json['result'],
      paymentStatus: json['payment_status']?.toString(),
      comments: json['comments'],
      amount: json['amount'],
      delStatus: json['del_status'],
      status: json['status'],
    );
  }
}