



import '../../../model/student_all_model/student_mocktest_review_model.dart';

abstract class StudentMocktestReviewState {}

class StudentMocktestReviewInitial
    extends StudentMocktestReviewState {}

class StudentMocktestReviewLoading
    extends StudentMocktestReviewState {}

class StudentMocktestReviewSuccess
    extends StudentMocktestReviewState {

  final StudentMocktestReviewModel mocktestReviewResponse;

  StudentMocktestReviewSuccess({

    required this.mocktestReviewResponse,
  });
}

class StudentMocktestReviewFailure
    extends StudentMocktestReviewState {

  final String error;

  StudentMocktestReviewFailure(
      this.error,
      );
}