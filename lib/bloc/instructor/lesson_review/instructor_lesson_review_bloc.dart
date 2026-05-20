

import 'package:amar_driving_school/bloc/instructor/lesson_review/instructor_lesson_review_event.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_review/instructor_lesson_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_lesson_review_api_service.dart';

class InstructorLessonReviewBloc extends Bloc<InstructorLessonReviewEvent, InstructorLessonReviewState> {

  InstructorLessonReviewBloc() : super(InstructorLessonReviewInitial(),) {

    on<SubmitInstructorLessonReview>(
          (event, emit) async {

        emit(
          InstructorLessonReviewLoading(),
        );

        try {

          final response =
          await InstructorLessonReviewApiService()
              .submitLessonReview(

            instructorId:
            event.instructorId,

            studentId:
            event.studentId,

            topicId:
            event.topicId,

            ratingsData:
            event.ratingsData,
          );

          emit(
            InstructorLessonReviewSuccess(

              reviewResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorLessonReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}