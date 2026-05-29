

import 'package:amar_driving_school/bloc/student/todays_lesson_list/student_todays_lesson_list_event.dart';
import 'package:amar_driving_school/bloc/student/todays_lesson_list/student_todays_lesson_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_todays_lesson_list_api_service.dart';

class StudentTodaysLessonListBloc extends Bloc<StudentTodaysLessonListEvent, StudentTodaysLessonListState> {

  StudentTodaysLessonListBloc()
      : super(
    StudentTodaysLessonListInitial(),
  ) {

    on<FetchStudentTodaysLessonList>(
          (event, emit) async {

        emit(
          StudentTodaysLessonListLoading(),
        );

        try {

          final response = await StudentTodaysLessonListApiService()
              .fetchTodaysLessonList(

            studentCode:
            event.studentCode,
          );

          emit(
            StudentTodaysLessonListSuccess(

              todaysLessonListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            StudentTodaysLessonListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}