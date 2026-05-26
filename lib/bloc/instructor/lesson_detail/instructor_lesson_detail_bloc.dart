
import 'package:amar_driving_school/bloc/instructor/lesson_detail/instructor_lesson_detail_event.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_detail/instructor_lesson_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_lesson_detail_Api_service.dart';

class InstructorLessonDetailBloc extends Bloc<InstructorLessonDetailEvent, InstructorLessonDetailState> {

  InstructorLessonDetailBloc() : super(InstructorLessonDetailInitial(),) {

    on<FetchInstructorLessonDetail>(
          (event, emit) async {

        emit(
          InstructorLessonDetailLoading(),
        );

        try {

          final response = await InstructorLessonDetailApiService()
              .fetchLessonDetail(

            lessonId:
            event.lessonId,
          );

          emit(
            InstructorLessonDetailSuccess(

              lessonDetailResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorLessonDetailFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}