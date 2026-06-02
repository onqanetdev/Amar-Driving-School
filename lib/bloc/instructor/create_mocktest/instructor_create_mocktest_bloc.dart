

import 'package:amar_driving_school/bloc/instructor/create_mocktest/instructor_create_mocktestEvent.dart';
import 'package:amar_driving_school/bloc/instructor/create_mocktest/instructor_create_mocktest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_create_mocktest_Api_service.dart';

class InstructorCreateMocktestBloc extends Bloc<InstructorCreateMocktestEvent, InstructorCreateMocktestState> {

  InstructorCreateMocktestBloc() : super(InstructorCreateMocktestInitial(),) {

    on<InstructorCreateMocktestTapped>(
          (event, emit) async {

        emit(
          InstructorCreateMocktestLoading(),
        );

        try {

          final response =
          await InstructorCreateMocktestApiService()
              .createMocktest(

            userid:
            event.userid,

            instructorid:
            event.instructorid,

            // name:
            // event.name,

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
            InstructorCreateMocktestSuccess(

              createMocktestResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorCreateMocktestFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}