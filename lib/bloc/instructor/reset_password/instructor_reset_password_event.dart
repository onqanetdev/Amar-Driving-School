

abstract class InstructorResetPasswordEvent {}

class InstructorResetPasswordTapped
    extends InstructorResetPasswordEvent {

  final String userId;
  final String otp;
  final String newPassword;

  InstructorResetPasswordTapped({

    required this.userId,
    required this.otp,
    required this.newPassword,
  });
}