

import '../../../model/instructor_lesson_delete_model/instructor_lesson_delete_model.dart';

abstract class InstructorLessonDeleteState {}

class InstructorLessonDeleteInitial extends InstructorLessonDeleteState {}

class InstructorLessonDeleteLoading extends InstructorLessonDeleteState {}

class InstructorLessonDeleteSuccess extends InstructorLessonDeleteState {

  final InstructorLessonDeleteModel deleteResponse;

  InstructorLessonDeleteSuccess({

    required this.deleteResponse,
  });
}

class InstructorLessonDeleteFailure extends InstructorLessonDeleteState {

  final String error;

  InstructorLessonDeleteFailure(
      this.error,
      );
}