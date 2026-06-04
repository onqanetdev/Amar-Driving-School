

import '../../../model/student_all_model/student_real_lesson_review_list_model.dart';

abstract class StudentRealLessonReviewState {}

class StudentRealLessonReviewInitial extends StudentRealLessonReviewState {}

class StudentRealLessonReviewLoading extends StudentRealLessonReviewState {}

class StudentRealLessonReviewSuccess extends StudentRealLessonReviewState {

  final StudentRealLessonReviewListModel lessonReviewResponse;

  StudentRealLessonReviewSuccess({

    required this.lessonReviewResponse,
  });
}

class StudentRealLessonReviewFailure
    extends StudentRealLessonReviewState {

  final String error;

  StudentRealLessonReviewFailure(
      this.error);
}