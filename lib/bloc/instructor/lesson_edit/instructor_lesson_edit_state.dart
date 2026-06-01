

import '../../../model/instructor_lesson_edit_model/instructor_lesson_edit_model.dart';

abstract class InstructorLessonEditState {}

class InstructorLessonEditInitial
    extends InstructorLessonEditState {}

class InstructorLessonEditLoading
    extends InstructorLessonEditState {}

class InstructorLessonEditSuccess
    extends InstructorLessonEditState {

  final InstructorLessonEdit lessonEditResponse;

  InstructorLessonEditSuccess({

    required this.lessonEditResponse,
  });
}

class InstructorLessonEditFailure
    extends InstructorLessonEditState {

  final String error;

  InstructorLessonEditFailure(
      this.error,
      );
}