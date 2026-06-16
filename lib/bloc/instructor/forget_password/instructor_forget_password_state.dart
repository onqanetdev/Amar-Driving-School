

import '../../../model/instructor_forgot_password_model/instructor_forgot_password_model.dart';

abstract class InstructorForgotPasswordState {}

class InstructorForgotPasswordInitial
    extends InstructorForgotPasswordState {}

class InstructorForgotPasswordLoading
    extends InstructorForgotPasswordState {}

class InstructorForgotPasswordSuccess
    extends InstructorForgotPasswordState {

  final InstructorForgotPasswordModel
  forgotPasswordResponse;

  InstructorForgotPasswordSuccess({

    required this.forgotPasswordResponse,
  });
}

class InstructorForgotPasswordFailure
    extends InstructorForgotPasswordState {

  final String error;

  InstructorForgotPasswordFailure(
      this.error,
      );
}