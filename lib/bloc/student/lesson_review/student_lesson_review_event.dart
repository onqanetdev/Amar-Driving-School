

abstract class StudentLessonReviewEvent {}

class FetchStudentLessonReview
    extends StudentLessonReviewEvent {

  final String studentCode;

  FetchStudentLessonReview({

    required this.studentCode,
  });
}