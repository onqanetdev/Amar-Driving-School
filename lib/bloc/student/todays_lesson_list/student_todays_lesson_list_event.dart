
abstract class StudentTodaysLessonListEvent {}

class FetchStudentTodaysLessonList
    extends StudentTodaysLessonListEvent {

  final String studentCode;

  FetchStudentTodaysLessonList({

    required this.studentCode,
  });
}