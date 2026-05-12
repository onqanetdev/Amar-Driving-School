

abstract class InstructorRegisterEvent { }

class InstructorRegTapped extends InstructorRegisterEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  InstructorRegTapped({
    required this.name,
    required this.email,
    required this.phone,
    required this.password
});

}