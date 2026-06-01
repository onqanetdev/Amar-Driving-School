

import '../../../model/student_all_model/student_mocktest_list_model.dart';

abstract class StudentMocktestListState {}

class StudentMocktestListInitial extends StudentMocktestListState {}

class StudentMocktestListLoading extends StudentMocktestListState {}

class StudentMocktestListSuccess extends StudentMocktestListState {

  final StudentMocktestListModel mocktestListResponse;

  StudentMocktestListSuccess({

    required this.mocktestListResponse,
  });
}

class StudentMocktestListFailure extends StudentMocktestListState {

  final String error;

  StudentMocktestListFailure(
      this.error,
      );
}