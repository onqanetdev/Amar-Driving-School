

import '../../../model/student_all_model/student_todays_lesson_list_model.dart';

abstract class StudentTodaysLessonListState {}

class StudentTodaysLessonListInitial
    extends StudentTodaysLessonListState {}

class StudentTodaysLessonListLoading
    extends StudentTodaysLessonListState {}

class StudentTodaysLessonListSuccess
    extends StudentTodaysLessonListState {

  final StudentTodaysLessonListModel todaysLessonListResponse;

  StudentTodaysLessonListSuccess({

    required this.todaysLessonListResponse,
  });
}

class StudentTodaysLessonListFailure
    extends StudentTodaysLessonListState {

  final String error;

  StudentTodaysLessonListFailure(
      this.error,
      );
}