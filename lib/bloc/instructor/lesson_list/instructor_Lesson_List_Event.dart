

abstract class InstructorLessonListEvent {}

class FetchInstructorLessonList
    extends InstructorLessonListEvent {

  final String instructorId;
  final String limit;
  final String offset;

  FetchInstructorLessonList({

    required this.instructorId,
    required this.limit,
    required this.offset,
  });
}