

import '../../../model/instructor_create_lesson_model/instructor_Lesson_List_Model.dart';

abstract class InstructorLessonListState {}

class InstructorLessonListInitial
    extends InstructorLessonListState {}

class InstructorLessonListLoading
    extends InstructorLessonListState {}

class InstructorLessonListSuccess
    extends InstructorLessonListState {

  final InstructorLessonListModel
  lessonListResponse;

  InstructorLessonListSuccess({

    required this.lessonListResponse,
  });
}

class InstructorLessonListFailure
    extends InstructorLessonListState {

  final String error;

  InstructorLessonListFailure(
      this.error,
      );
}