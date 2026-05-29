

import '../../../model/student_all_model/student_todays_lesson_mocktest_list_model.dart';

abstract class StudentTodaysMocktestListState {}

class StudentTodaysMocktestListInitial
    extends StudentTodaysMocktestListState {}

class StudentTodaysMocktestListLoading
    extends StudentTodaysMocktestListState {}

class StudentTodaysMocktestListSuccess
    extends StudentTodaysMocktestListState {

  final StudentTodaysMocktestList todaysMocktestListResponse;

  StudentTodaysMocktestListSuccess({

    required this.todaysMocktestListResponse,
  });
}

class StudentTodaysMocktestListFailure
    extends StudentTodaysMocktestListState {

  final String error;

  StudentTodaysMocktestListFailure(
      this.error,
      );
}