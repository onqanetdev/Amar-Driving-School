
import 'package:amar_driving_school/model/instructor_register/instructor_register_model.dart';

abstract class InstructorRegisterState { }

class InstructorRegisterInitial extends InstructorRegisterState { }
class InstructorRegisterLoading extends InstructorRegisterState { }
class InstructorRegisterSuccess extends InstructorRegisterState {
  final InstructorRegisterModel instructRegResponseData;
  InstructorRegisterSuccess({required this.instructRegResponseData});
}

class InstructorRegisterFailure extends InstructorRegisterState {
  final String error;
  InstructorRegisterFailure(this.error);
}