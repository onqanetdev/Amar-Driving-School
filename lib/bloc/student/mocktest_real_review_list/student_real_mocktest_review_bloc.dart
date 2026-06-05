

import 'package:amar_driving_school/bloc/student/mocktest_real_review_list/student_real_mocktest_review_event.dart';
import 'package:amar_driving_school/bloc/student/mocktest_real_review_list/student_real_mocktest_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_real_mocktest_review_api_service.dart';

class StudentRealMocktestReviewBloc extends Bloc<StudentRealMocktestReviewEvent, StudentRealMocktestReviewState> {

  final StudentRealMocktestReviewApiService apiService = StudentRealMocktestReviewApiService();

  StudentRealMocktestReviewBloc()
      : super(StudentRealMocktestReviewInitial(),) {

    on<FetchStudentRealMocktestReview>(
          (event, emit) async {

        emit(
          StudentRealMocktestReviewLoading(),
        );

        try {

          final response =
          await apiService
              .fetchMocktestReviewList(

            studentCode:
            event.studentCode,

            topicId:
            event.topicId,
          );

          emit(
            StudentRealMocktestReviewSuccess(

              mocktestReviewResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            StudentRealMocktestReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}