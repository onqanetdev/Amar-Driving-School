

import 'package:amar_driving_school/bloc/student/lesson_review/student_lesson_review_event.dart';
import 'package:amar_driving_school/bloc/student/lesson_review/student_lesson_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_lesson_review_api_service.dart';

class StudentLessonReviewBloc extends Bloc<StudentLessonReviewEvent, StudentLessonReviewState> {

  StudentLessonReviewBloc() : super(StudentLessonReviewInitial(),) {

    on<FetchStudentLessonReview>(
          (event, emit) async {

        emit(
          StudentLessonReviewLoading(),
        );

        try {

          final response = await StudentLessonReviewApiService().fetchLessonReview(

            studentCode:
            event.studentCode,
          );

          emit(
            StudentLessonReviewSuccess(

              lessonReviewResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            StudentLessonReviewFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}