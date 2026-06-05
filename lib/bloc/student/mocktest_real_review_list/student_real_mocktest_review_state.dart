

import '../../../model/student_all_model/student_real_mocktest_review_list_model.dart';

abstract class StudentRealMocktestReviewState {}

class StudentRealMocktestReviewInitial
    extends StudentRealMocktestReviewState {}

class StudentRealMocktestReviewLoading
    extends StudentRealMocktestReviewState {}

class StudentRealMocktestReviewSuccess
    extends StudentRealMocktestReviewState {

  final StudentRealMocktestReviewListModel mocktestReviewResponse;

  StudentRealMocktestReviewSuccess({

    required this.mocktestReviewResponse,
  });
}

class StudentRealMocktestReviewFailure
    extends StudentRealMocktestReviewState {

  final String error;

  StudentRealMocktestReviewFailure(this.error);
}