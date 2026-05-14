

import 'package:amar_driving_school/model/instructor_create_lesson_model/instructor_create_lesson_model.dart';

abstract class InstructorCreateLessonState {}

class InstructorCreateLessonInitial
    extends InstructorCreateLessonState {}

class InstructorCreateLessonLoading
    extends InstructorCreateLessonState {}

class InstructorCreateLessonSuccess
    extends InstructorCreateLessonState {

  final InstructorCreateLessonModel
  createLessonResponse;

  InstructorCreateLessonSuccess({

    required this.createLessonResponse,
  });
}

class InstructorCreateLessonFailure
    extends InstructorCreateLessonState {

  final String error;

  InstructorCreateLessonFailure(
      this.error,
      );
}