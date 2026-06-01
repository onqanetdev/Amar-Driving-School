

abstract class StudentMocktestReviewEvent {}

class FetchStudentMocktestReview
    extends StudentMocktestReviewEvent {

  final String studentCode;

  FetchStudentMocktestReview({

    required this.studentCode,
  });
}