

import 'package:amar_driving_school/ApiService/instructor_lesson_list_api_service.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_list/instructor_Lesson_List_Event.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_list/instructor_lesson_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorLessonListBloc extends Bloc<InstructorLessonListEvent, InstructorLessonListState> {

  InstructorLessonListBloc() : super(InstructorLessonListInitial(),) {

    on<FetchInstructorLessonList>(
          (event, emit) async {

        emit(
          InstructorLessonListLoading(),
        );

        try {

          final response =
          await InstructorLessonListApiService()
              .fetchLessonList(

            instructorId:
            event.instructorId,

            limit:
            event.limit,

            offset:
            event.offset,
          );

          emit(
            InstructorLessonListSuccess(
              lessonListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorLessonListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}