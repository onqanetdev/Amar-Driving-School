

import 'package:amar_driving_school/bloc/student/lesson_list/student_lesson_list_event.dart';
import 'package:amar_driving_school/bloc/student/lesson_list/student_lesson_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_lesson_list_api_service.dart';

class StudentLessonListBloc extends Bloc<StudentLessonListEvent, StudentLessonListState> {

  StudentLessonListBloc() : super(StudentLessonListInitial(),) {

    on<FetchStudentLessonList>(
          (event, emit) async {

        emit(
          StudentLessonListLoading(),
        );

        try {

          final response = await StudentLessonListApiService()
              .fetchLessonList(

            studentId:
            event.studentId,

            limit:
            event.limit,

            offset:
            event.offset,
          );

          emit(
            StudentLessonListSuccess(

              lessonListResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            StudentLessonListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}