import 'package:amar_driving_school/model/student_login/student_login_res_model.dart';

abstract class StudentLoginState { }

class StudentLoginInitial extends StudentLoginState { }
class StudentLoginLoading extends StudentLoginState { }
class StudentLoginSuccess extends StudentLoginState {
  final StudentLoginResModel studResdata;
  StudentLoginSuccess({required this.studResdata});
}

class StudentLoginFailure extends StudentLoginState {
  final String error;
  StudentLoginFailure(this.error);
}