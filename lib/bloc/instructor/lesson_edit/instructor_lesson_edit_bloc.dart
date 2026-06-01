

import 'package:amar_driving_school/bloc/instructor/lesson_edit/instructor_lesson_edit_event.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_edit/instructor_lesson_edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_lesson_edit_api_service.dart';

class InstructorLessonEditBloc extends Bloc<InstructorLessonEditEvent, InstructorLessonEditState> {

  final UpdateLessonApiService apiService = UpdateLessonApiService();

  InstructorLessonEditBloc()
      : super(
    InstructorLessonEditInitial(),
  ) {

    on<InstructorLessonEditTapped>(
          (event, emit) async {

        emit(
          InstructorLessonEditLoading(),
        );

        try {

          final response =
          await apiService
              .updateLesson(

            userid:
            event.userid,

            instructorid:
            event.instructorid,

            startDate:
            event.startDate,

            startTime:
            event.startTime,

            duration:
            event.duration,

            topicId:
            event.topicId,

            subtopicId:
            event.subtopicId,
          );

          emit(
            InstructorLessonEditSuccess(

              lessonEditResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            InstructorLessonEditFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}
