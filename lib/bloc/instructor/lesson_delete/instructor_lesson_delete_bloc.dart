
import 'package:amar_driving_school/bloc/instructor/lesson_delete/instructor_lesson_delete_event.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_delete/instructor_lesson_delete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_lesson_delete_api_service.dart';

class InstructorLessonDeleteBloc extends Bloc<InstructorLessonDeleteEvent, InstructorLessonDeleteState> {

  InstructorLessonDeleteBloc() : super(InstructorLessonDeleteInitial(),) {

    on<DeleteInstructorLesson>(
          (event, emit) async {

        emit(
          InstructorLessonDeleteLoading(),
        );

        try {

          final response = await InstructorLessonDeleteApiService().deleteLesson(
            lessonId: event.lessonId,
          );

          emit(
            InstructorLessonDeleteSuccess(

              deleteResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorLessonDeleteFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}