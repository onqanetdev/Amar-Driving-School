


import 'package:amar_driving_school/bloc/student/mocktest_review/student_mocktest_review_event.dart';
import 'package:amar_driving_school/bloc/student/mocktest_review/student_mocktest_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_mocktest_review_api_service.dart';

class StudentMocktestReviewBloc extends Bloc<StudentMocktestReviewEvent, StudentMocktestReviewState> {

  StudentMocktestReviewBloc()
      : super(StudentMocktestReviewInitial(),) {

    on<FetchStudentMocktestReview>(
          (event, emit) async {

        emit(
          StudentMocktestReviewLoading(),
        );

        try {

          final response = await StudentMocktestReviewApiService()
              .fetchMocktestReviewList(

            studentCode:
            event.studentCode,
          );

          emit(
            StudentMocktestReviewSuccess(

              mocktestReviewResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            StudentMocktestReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}