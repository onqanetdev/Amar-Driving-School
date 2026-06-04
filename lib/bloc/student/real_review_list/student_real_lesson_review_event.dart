

abstract class StudentRealLessonReviewEvent {}

class FetchStudentRealLessonReview
    extends StudentRealLessonReviewEvent {

  final String studentCode;
  final String topicId;

  FetchStudentRealLessonReview({

    required this.studentCode,
    required this.topicId,
  });
}