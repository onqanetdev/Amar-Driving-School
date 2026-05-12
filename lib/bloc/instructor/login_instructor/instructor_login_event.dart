

abstract class InstructorLoginEvent { }

class InstructorLoginTapped extends InstructorLoginEvent {
  final String email;
  final String password;
  InstructorLoginTapped ({
    required this.email,
    required this.password
  }
  );
}