

import '../../../model/instructor_mocktest_delete_model/instructor_mocktest_delete_model.dart';

abstract class InstructorMocktestDeleteState {}

class InstructorMocktestDeleteInitial
    extends InstructorMocktestDeleteState {}

class InstructorMocktestDeleteLoading
    extends InstructorMocktestDeleteState {}

class InstructorMocktestDeleteSuccess
    extends InstructorMocktestDeleteState {

  final InstructorMocktestDeleteModel deleteResponse;

  InstructorMocktestDeleteSuccess({

    required this.deleteResponse,
  });
}

class InstructorMocktestDeleteFailure
    extends InstructorMocktestDeleteState {

  final String error;

  InstructorMocktestDeleteFailure(
      this.error,
      );
}