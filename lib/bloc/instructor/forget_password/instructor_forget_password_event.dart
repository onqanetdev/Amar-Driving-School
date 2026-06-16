

abstract class InstructorForgotPasswordEvent {}

class InstructorForgotPasswordTapped
    extends InstructorForgotPasswordEvent {

  final String email;

  InstructorForgotPasswordTapped({

    required this.email,
  });
}