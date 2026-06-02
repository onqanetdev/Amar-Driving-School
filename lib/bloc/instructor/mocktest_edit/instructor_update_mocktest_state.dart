

import '../../../model/instructor_update_mocktest_model/instructor_update_mocktest_model.dart';

abstract class InstructorUpdateMocktestState {}

class InstructorUpdateMocktestInitial extends InstructorUpdateMocktestState {}

class InstructorUpdateMocktestLoading extends InstructorUpdateMocktestState {}

class InstructorUpdateMocktestSuccess extends InstructorUpdateMocktestState {

  final InstructorUpdateMocktestModel updateMocktestResponse;

  InstructorUpdateMocktestSuccess({

    required this.updateMocktestResponse,
  });
}

class InstructorUpdateMocktestFailure extends InstructorUpdateMocktestState {

  final String error;

  InstructorUpdateMocktestFailure(
      this.error);
}