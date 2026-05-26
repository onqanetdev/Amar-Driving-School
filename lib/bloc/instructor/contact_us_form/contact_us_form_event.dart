

abstract class InstructorContactUsEvent {}

class SubmitInstructorContactUs
    extends InstructorContactUsEvent {

  final String firstName;

  final String lastName;

  final String email;

  final String contact;

  final String message;

  SubmitInstructorContactUs({

    required this.firstName,

    required this.lastName,

    required this.email,

    required this.contact,

    required this.message,
  });
}
