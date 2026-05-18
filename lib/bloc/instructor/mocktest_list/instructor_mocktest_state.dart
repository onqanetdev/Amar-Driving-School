

import '../../../model/instructor_create_mocktest/instructor_mocktest_list_model.dart';

abstract class InstructorMocktestListState {}

class InstructorMocktestListInitial
    extends InstructorMocktestListState {}

class InstructorMocktestListLoading
    extends InstructorMocktestListState {}

class InstructorMocktestListSuccess
    extends InstructorMocktestListState {

  final InstructorMocktestListModel mocktestListResponse;

  InstructorMocktestListSuccess({

    required this.mocktestListResponse,
  });
}

class InstructorMocktestListFailure
    extends InstructorMocktestListState {

  final String error;

  InstructorMocktestListFailure(
      this.error,
      );
}