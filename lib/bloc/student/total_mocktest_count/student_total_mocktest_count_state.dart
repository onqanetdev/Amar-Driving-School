

import '../../../model/student_all_model/student_total_mocktest_count_model.dart';

abstract class StudentTotalMocktestCountState {}

class StudentTotalMocktestCountInitial
    extends StudentTotalMocktestCountState {}

class StudentTotalMocktestCountLoading
    extends StudentTotalMocktestCountState {}

class StudentTotalMocktestCountSuccess
    extends StudentTotalMocktestCountState {

  final StudentTotalMocktestCountModel totalMocktestCountResponse;

  StudentTotalMocktestCountSuccess({

    required this.totalMocktestCountResponse,
  });
}

class StudentTotalMocktestCountFailure
    extends StudentTotalMocktestCountState {

  final String error;

  StudentTotalMocktestCountFailure(
      this.error,
      );
}