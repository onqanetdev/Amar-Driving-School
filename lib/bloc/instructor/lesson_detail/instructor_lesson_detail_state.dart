
import '../../../model/instructor_lesson_detail_model/instructor_lesson_detail_model.dart';

abstract class InstructorLessonDetailState {}

class InstructorLessonDetailInitial extends InstructorLessonDetailState {}

class InstructorLessonDetailLoading extends InstructorLessonDetailState {}

class InstructorLessonDetailSuccess extends InstructorLessonDetailState {

  final InstructorLessonDetailModel lessonDetailResponse;

  InstructorLessonDetailSuccess({

    required this.lessonDetailResponse,
  });
}

class InstructorLessonDetailFailure extends InstructorLessonDetailState {

  final String error;

  InstructorLessonDetailFailure(
      this.error,
      );
}