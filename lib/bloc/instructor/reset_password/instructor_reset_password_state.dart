

import '../../../model/instructor_reset_password_model/instructor_reset_password_model.dart';

abstract class InstructorResetPasswordState {}

class InstructorResetPasswordInitial
    extends InstructorResetPasswordState {}

class InstructorResetPasswordLoading
    extends InstructorResetPasswordState {}

class InstructorResetPasswordSuccess
    extends InstructorResetPasswordState {

  final InstructorResetPasswordModel resetPasswordResponse;

  InstructorResetPasswordSuccess({

    required this.resetPasswordResponse,
  });
}

class InstructorResetPasswordFailure
    extends InstructorResetPasswordState {

  final String error;

  InstructorResetPasswordFailure(
      this.error,
      );
}