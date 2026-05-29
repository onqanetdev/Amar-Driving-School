
abstract class StudentTotalLessonCountEvent {}

class FetchStudentTotalLessonCount
    extends StudentTotalLessonCountEvent {

  final String userId;

  FetchStudentTotalLessonCount({

    required this.userId,
  });
}