

import 'package:amar_driving_school/bloc/student/total_lesson_count/student_total_lesson_count_event.dart';
import 'package:amar_driving_school/bloc/student/total_lesson_count/student_total_lesson_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_total_lesson_count_api_service.dart';

class StudentTotalLessonCountBloc extends Bloc<StudentTotalLessonCountEvent, StudentTotalLessonCountState> {

  StudentTotalLessonCountBloc()
      : super(
    StudentTotalLessonCountInitial(),
  ) {

    on<FetchStudentTotalLessonCount>(
          (event, emit) async {

        emit(
          StudentTotalLessonCountLoading(),
        );

        try {

          final response =
          await StudentTotalLessonCountApiService()
              .fetchTotalLessonCount(

            userId:
            event.userId,
          );

          emit(
            StudentTotalLessonCountSuccess(

              totalLessonCountResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            StudentTotalLessonCountFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}