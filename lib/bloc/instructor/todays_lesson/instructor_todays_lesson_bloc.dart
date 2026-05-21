

import 'package:amar_driving_school/bloc/instructor/todays_lesson/instructor_todays_lesson_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_todays_lesson_api_service.dart';
import 'instructor_todays_lesson_event.dart';

class InstructorTodaysLessonBloc extends Bloc<InstructorTodaysLessonEvent, InstructorTodaysLessonState> {

  InstructorTodaysLessonBloc()
      : super(
    InstructorTodaysLessonInitial(),
  ) {

    on<FetchInstructorTodaysLesson>(
          (event, emit) async {

        emit(
          InstructorTodaysLessonLoading(),
        );

        try {

          final response = await InstructorTodaysLessonApiService()
              .fetchTodaysLesson(

            instructorId:
            event.instructorId,
          );

          emit(
            InstructorTodaysLessonSuccess(

              todaysLessonResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorTodaysLessonFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}