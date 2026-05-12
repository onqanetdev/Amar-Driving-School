

abstract class InstructorStudentListEvent {}

class FetchInstructorStudentList
    extends InstructorStudentListEvent {

  final String instructureId;

  FetchInstructorStudentList({
    required this.instructureId,
  });
}