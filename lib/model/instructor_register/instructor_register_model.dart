
class InstructorRegisterModel {

  final int status;
  final bool success;
  final String message;
  final InstructorData? instructor;

  InstructorRegisterModel({

    required this.status,
    required this.success,
    required this.message,
    this.instructor,
  });

  factory InstructorRegisterModel.fromJson(
      Map<String, dynamic> json) {

    String parsedMessage = '';

    if (json['message'] is String) {

      parsedMessage = json['message'];

    } else if (json['message'] is Map) {

      parsedMessage =
          (json['message'] as Map)
              .values
              .join('\n');
    }

    return InstructorRegisterModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      message: parsedMessage,

      instructor: json['instructor'] != null
          ? InstructorData.fromJson(
        json['instructor'],
      )
          : null,
    );
  }
}

class InstructorData {

  final String userId;
  final String loginId;
  final String regDate;
  final String name;

  final dynamic age;
  final dynamic surname;

  final String email;
  final String phone;

  final dynamic licenseNo;
  final dynamic carNo;
  final dynamic assignHour;
  final dynamic startdate;
  final dynamic pickupLocation;
  final dynamic dropLocation;
  final dynamic profilePicture;

  final String instructureId;

  final dynamic packageId;

  final String givenHour;
  final String role;

  final dynamic trainingStatus;
  final dynamic result;
  final dynamic paymentStatus;
  final dynamic comments;

  final String amount;
  final String delStatus;
  final String status;

  InstructorData({

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

  factory InstructorData.fromJson(
      Map<String, dynamic> json) {

    return InstructorData(

      userId: json['user_id'] ?? '',

      loginId: json['login_id'] ?? '',

      regDate: json['reg_date'] ?? '',

      name: json['name'] ?? '',

      age: json['age'],

      surname: json['surname'],

      email: json['email'] ?? '',

      phone: json['phone'] ?? '',

      licenseNo: json['license_no'],

      carNo: json['car_no'],

      assignHour: json['assign_hour'],

      startdate: json['startdate'],

      pickupLocation: json['pickup_location'],

      dropLocation: json['drop_location'],

      profilePicture: json['profile_picture'],

      instructureId:
      json['instructure_id'] ?? '',

      packageId: json['package_id'],

      givenHour:
      json['given_hour'] ?? '',

      role: json['role'] ?? '',

      trainingStatus:
      json['training_status'],

      result: json['result'],

      paymentStatus:
      json['payment_status'],

      comments: json['comments'],

      amount: json['amount'] ?? '',

      delStatus:
      json['del_status'] ?? '',

      status: json['status'] ?? '',
    );
  }
}