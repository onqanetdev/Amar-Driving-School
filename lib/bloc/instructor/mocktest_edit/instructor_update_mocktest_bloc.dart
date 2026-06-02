

import 'package:amar_driving_school/bloc/instructor/mocktest_edit/instructor_update_mocktest_event.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_edit/instructor_update_mocktest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_mocktest_api_service.dart';

class InstructorUpdateMocktestBloc extends Bloc<InstructorUpdateMocktestEvent, InstructorUpdateMocktestState> {

  final MocktestUpdateApiService apiService = MocktestUpdateApiService();

  InstructorUpdateMocktestBloc()
      : super(
    InstructorUpdateMocktestInitial(),
  ) {

    on<InstructorUpdateMocktestTapped>(
          (event, emit) async {

        emit(
          InstructorUpdateMocktestLoading(),
        );

        try {

          final response =
          await apiService
              .updateMocktest(

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
            InstructorUpdateMocktestSuccess(

              updateMocktestResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            InstructorUpdateMocktestFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}