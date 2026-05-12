

abstract class InstructorAddStudentEvent {}

class InstructorAddStudentTapped
    extends InstructorAddStudentEvent {

  final String name;
  final String age;
  final String startdate;
  final String email;
  final String duration;
  final String price;
  final String instructureid;
  final String paymentstatus;
  final String phone;

  InstructorAddStudentTapped({

    required this.name,
    required this.age,
    required this.startdate,
    required this.email,
    required this.duration,
    required this.price,
    required this.instructureid,
    required this.paymentstatus,
    required this.phone,

  });
}