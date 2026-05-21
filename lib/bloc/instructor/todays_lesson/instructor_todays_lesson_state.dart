

import '../../../model/instructor_todays_lesson_model/instructor_todays_lesson_model.dart';

abstract class InstructorTodaysLessonState {}

class InstructorTodaysLessonInitial extends InstructorTodaysLessonState {}

class InstructorTodaysLessonLoading extends InstructorTodaysLessonState {}

class InstructorTodaysLessonSuccess extends InstructorTodaysLessonState {

  final InstructorTodaysLessonModel todaysLessonResponse;

  InstructorTodaysLessonSuccess({

    required this.todaysLessonResponse,
  });
}

class InstructorTodaysLessonFailure extends InstructorTodaysLessonState {

  final String error;

  InstructorTodaysLessonFailure(
      this.error,
      );
}