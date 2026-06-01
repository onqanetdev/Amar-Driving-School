
abstract class StudentLessonListEvent {}

class FetchStudentLessonList
    extends StudentLessonListEvent {

  final String studentId;
  final String limit;
  final String offset;

  FetchStudentLessonList({

    required this.studentId,
    required this.limit,
    required this.offset,
  });
}