
import 'package:amar_driving_school/model/instructor_login/instructor_login_model.dart';

abstract class InstructorLoginState { }

class InstructorLoginInitial extends InstructorLoginState { }
class InstructorLoginLoading extends InstructorLoginState { }

class InstructorLoginSuccess extends InstructorLoginState {
  final InstructorLoginModel responseInstructorLogin;
  InstructorLoginSuccess({ required this.responseInstructorLogin});
}

class InstructorLoginFailure extends InstructorLoginState {
  final String error;
  InstructorLoginFailure(this.error);
}
