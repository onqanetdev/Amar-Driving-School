

abstract class InstructorStudentDeleteEvent {}

class InstructorStudentDeleteTapped
    extends InstructorStudentDeleteEvent {

  final String instructorId;
  final String studentId;

  InstructorStudentDeleteTapped({

    required this.instructorId,
    required this.studentId,
  });
}