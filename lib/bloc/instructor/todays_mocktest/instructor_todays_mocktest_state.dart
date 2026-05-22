
import '../../../model/instructor_todays_mocktest_model/instructor_todays_mocktest_model.dart';

abstract class InstructorTodaysMocktestState {}

class InstructorTodaysMocktestInitial
    extends InstructorTodaysMocktestState {}

class InstructorTodaysMocktestLoading
    extends InstructorTodaysMocktestState {}

class InstructorTodaysMocktestSuccess
    extends InstructorTodaysMocktestState {

  final InstructorTodaysMocktestModel todaysMocktestResponse;

  InstructorTodaysMocktestSuccess({

    required this.todaysMocktestResponse,
  });
}

class InstructorTodaysMocktestFailure
    extends InstructorTodaysMocktestState {

  final String error;

  InstructorTodaysMocktestFailure(
      this.error,
      );
}