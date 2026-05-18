

abstract class InstructorStudentCountEvent {}

class FetchInstructorStudentCount
    extends InstructorStudentCountEvent {

  final String instructorId;

  FetchInstructorStudentCount({

    required this.instructorId,
  });
}