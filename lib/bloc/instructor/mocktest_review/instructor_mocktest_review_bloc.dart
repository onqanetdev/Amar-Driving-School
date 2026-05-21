

import 'package:amar_driving_school/bloc/instructor/mocktest_review/instructor_mocktest_review_event.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_review/instructor_mocktest_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_mocktest_review_api_service.dart';

class InstructorMocktestReviewBloc extends Bloc<InstructorMocktestReviewEvent, InstructorMocktestReviewState> {

  InstructorMocktestReviewBloc() : super(
    InstructorMocktestReviewInitial(),
  ) {
    on<SubmitInstructorMocktestReview>(
          (event, emit) async {

        emit(
          InstructorMocktestReviewLoading(),
        );

        try {

          final response =
          await InstructorMocktestReviewApiService()
              .submitMocktestReview(

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
            InstructorMocktestReviewSuccess(

              reviewResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorMocktestReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}