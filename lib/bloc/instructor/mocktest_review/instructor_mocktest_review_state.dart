

import '../../../model/instructor_mocktest_review/instructor_mocktest_review_model.dart';

abstract class InstructorMocktestReviewState {}

class InstructorMocktestReviewInitial
    extends InstructorMocktestReviewState {}

class InstructorMocktestReviewLoading
    extends InstructorMocktestReviewState {}

class InstructorMocktestReviewSuccess
    extends InstructorMocktestReviewState {

  final InstructorMocktestReviewModel reviewResponse;

  InstructorMocktestReviewSuccess({

    required this.reviewResponse,
  });
}

class InstructorMocktestReviewFailure extends InstructorMocktestReviewState {

  final String error;

  InstructorMocktestReviewFailure(
      this.error,
      );
}