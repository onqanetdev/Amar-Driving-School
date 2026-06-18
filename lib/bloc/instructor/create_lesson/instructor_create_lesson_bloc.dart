
import 'package:amar_driving_school/ApiService/instructor_create_lesson_api_service.dart';
import 'package:amar_driving_school/bloc/instructor/create_lesson/instructor_create_lesson_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'instructor_create_lesson_event.dart';

class InstructorCreateLessonBloc extends Bloc<InstructorCreateLessonEvent, InstructorCreateLessonState> {

  InstructorCreateLessonBloc() : super(InstructorCreateLessonInitial(),) {

    on<InstructorCreateLessonTapped>(
          (event, emit) async {

        emit(
          InstructorCreateLessonLoading(),
        );

        try {

          final response =
          await CreateLessonApiService()
              .createLesson(

            userid: event.userid,
            instructorid: event.instructorid,
            //name: event.name,
            startDate: event.startDate,
            startTime: event.startTime,
            duration: event.duration,
            topicId: event.topicId,
            subtopicId: event.subtopicId,
          );

          emit(
            InstructorCreateLessonSuccess(
              createLessonResponse:
              response,
            ),
          );

        } catch (e) {
          emit(
            InstructorCreateLessonFailure(
              e.toString().replaceFirst('Exception: ', ''),
            ),
          );
        }
      },
    );
  }
}
