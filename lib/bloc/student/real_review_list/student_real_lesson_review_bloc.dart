


import 'package:amar_driving_school/bloc/student/real_review_list/student_real_lesson_review_event.dart';
import 'package:amar_driving_school/bloc/student/real_review_list/student_real_lesson_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_real_lesson_review_api_service.dart';

class StudentRealLessonReviewBloc extends Bloc<StudentRealLessonReviewEvent, StudentRealLessonReviewState> {

  final StudentRealLessonReviewApiService apiService = StudentRealLessonReviewApiService();

  StudentRealLessonReviewBloc() : super(StudentRealLessonReviewInitial(),) {

    on<FetchStudentRealLessonReview>(
          (event, emit) async {

        emit(
          StudentRealLessonReviewLoading(),
        );

        try {

          final response =
          await apiService
              .fetchLessonReviewList(

            studentCode:
            event.studentCode,

            topicId:
            event.topicId,
          );

          emit(
            StudentRealLessonReviewSuccess(

              lessonReviewResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            StudentRealLessonReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}