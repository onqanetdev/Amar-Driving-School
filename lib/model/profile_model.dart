
class InstructorProfileModel {

  final int status;
  final bool success;
  final String message;
  final ProfileData data;

  InstructorProfileModel({

    required this.status,

    required this.success,

    required this.message,

    required this.data,
  });

  factory InstructorProfileModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorProfileModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: ProfileData.fromJson(
        json['data'],
      ),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data.toJson(),
    };
  }
}

class ProfileData {

  final String userId;
  final String loginId;
  final String regDate;
  final String name;
  final dynamic age;
  final dynamic surname;
  final String email;
  final String phone;
  final dynamic assignHour;
  final dynamic startdate;
  final dynamic profilePicture;
  final String instructureId;
  final String role;
  final dynamic result;
  final dynamic paymentStatus;
  final dynamic comments;
  final String amount;
  final String delStatus;
  final String status;

  ProfileData({

    required this.userId,

    required this.loginId,

    required this.regDate,

    required this.name,

    required this.age,

    required this.surname,

    required this.email,

    required this.phone,

    required this.assignHour,

    required this.startdate,

    required this.profilePicture,

    required this.instructureId,

    required this.role,

    required this.result,

    required this.paymentStatus,

    required this.comments,

    required this.amount,

    required this.delStatus,

    required this.status,
  });

  factory ProfileData.fromJson(
      Map<String, dynamic> json) {

    return ProfileData(

      userId: json['user_id'],

      loginId: json['login_id'],

      regDate: json['reg_date'],

      name: json['name'],

      age: json['age'],

      surname: json['surname'],

      email: json['email'],

      phone: json['phone'],

      assignHour: json['assign_hour'],

      startdate: json['startdate'],

      profilePicture: json['profile_picture'],

      instructureId: json['instructure_id'],

      role: json['role'],

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

      'assign_hour': assignHour,

      'startdate': startdate,

      'profile_picture': profilePicture,

      'instructure_id': instructureId,

      'role': role,

      'result': result,

      'payment_status': paymentStatus,

      'comments': comments,

      'amount': amount,

      'del_status': delStatus,

      'status': status,
    };
  }
}