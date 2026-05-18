

import '../../../model/instructor_create_mocktest/instructor_create_mocktest_model.dart';

abstract class InstructorCreateMocktestState {}

class InstructorCreateMocktestInitial
    extends InstructorCreateMocktestState {}

class InstructorCreateMocktestLoading
    extends InstructorCreateMocktestState {}

class InstructorCreateMocktestSuccess
    extends InstructorCreateMocktestState {

  final InstructorCreateMocktestModel createMocktestResponse;

  InstructorCreateMocktestSuccess({

    required this.createMocktestResponse,
  });
}

class InstructorCreateMocktestFailure
    extends InstructorCreateMocktestState {

  final String error;

  InstructorCreateMocktestFailure(
      this.error,
      );
}