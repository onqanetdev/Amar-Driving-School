
import '../../../model/instructor_lesson_review/instructor_lesson_review_model.dart';

abstract class InstructorLessonReviewState {}

class InstructorLessonReviewInitial
    extends InstructorLessonReviewState {}

class InstructorLessonReviewLoading
    extends InstructorLessonReviewState {}

class InstructorLessonReviewSuccess
    extends InstructorLessonReviewState {

  final InstructorLessonReviewModel reviewResponse;

  InstructorLessonReviewSuccess({

    required this.reviewResponse,
  });
}

class InstructorLessonReviewFailure
    extends InstructorLessonReviewState {

  final String error;

  InstructorLessonReviewFailure(
      this.error,
      );
}