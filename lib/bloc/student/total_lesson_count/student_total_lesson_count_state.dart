

import '../../../model/student_all_model/student_total_lesson_count.dart';

abstract class StudentTotalLessonCountState {}

class StudentTotalLessonCountInitial
    extends StudentTotalLessonCountState {}

class StudentTotalLessonCountLoading
    extends StudentTotalLessonCountState {}

class StudentTotalLessonCountSuccess
    extends StudentTotalLessonCountState {

  final StudentTotalLessonCount totalLessonCountResponse;

  StudentTotalLessonCountSuccess({

    required this.totalLessonCountResponse,
  });
}

class StudentTotalLessonCountFailure
    extends StudentTotalLessonCountState {

  final String error;

  StudentTotalLessonCountFailure(
      this.error,
      );
}