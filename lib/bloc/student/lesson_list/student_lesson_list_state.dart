

import '../../../model/student_all_model/student_lesson_list_model.dart';

abstract class StudentLessonListState {}

class StudentLessonListInitial
    extends StudentLessonListState {}

class StudentLessonListLoading
    extends StudentLessonListState {}

class StudentLessonListSuccess
    extends StudentLessonListState {

  final StudentLessonListModel lessonListResponse;

  StudentLessonListSuccess({

    required this.lessonListResponse,
  });
}

class StudentLessonListFailure
    extends StudentLessonListState {

  final String error;

  StudentLessonListFailure(
      this.error,
      );
}