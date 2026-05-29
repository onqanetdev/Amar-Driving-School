

import '../../../model/student_all_model/student_lesson_review.dart';

abstract class StudentLessonReviewState {}

class StudentLessonReviewInitial
    extends StudentLessonReviewState {}

class StudentLessonReviewLoading
    extends StudentLessonReviewState {}

class StudentLessonReviewSuccess
    extends StudentLessonReviewState {

  final StudentLessonReview lessonReviewResponse;

  StudentLessonReviewSuccess({

    required this.lessonReviewResponse,
  });
}

class StudentLessonReviewFailure
    extends StudentLessonReviewState {

  final String error;

  StudentLessonReviewFailure(
      this.error,
      );
}