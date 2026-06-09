

abstract class InstructorStudentUpdateEvent {}

class SubmitInstructorStudentUpdate
    extends InstructorStudentUpdateEvent {

  final String userId;
  final String name;
  final String age;
  final String startDate;
  final String phone;
  final String duration;
  final String price;
  final String paymentStatus;

  SubmitInstructorStudentUpdate({
    required this.userId,
    required this.name,
    required this.age,
    required this.startDate,
    required this.phone,
    required this.duration,
    required this.price,
    required this.paymentStatus,
  });
}