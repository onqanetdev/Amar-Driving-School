

abstract class StudentRealMocktestReviewEvent {}

class FetchStudentRealMocktestReview
    extends StudentRealMocktestReviewEvent {

  final String studentCode;
  final String topicId;

  FetchStudentRealMocktestReview({

    required this.studentCode,
    required this.topicId,
  });
}