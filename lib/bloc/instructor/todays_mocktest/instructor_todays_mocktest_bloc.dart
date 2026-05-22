

import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_event.dart';
import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_todays_mocktest_api_service.dart';

class InstructorTodaysMocktestBloc extends Bloc<InstructorTodaysMocktestEvent, InstructorTodaysMocktestState> {

  InstructorTodaysMocktestBloc()
      : super(
    InstructorTodaysMocktestInitial(),
  ) {

    on<FetchInstructorTodaysMocktest>(
          (event, emit) async {

        emit(
          InstructorTodaysMocktestLoading(),
        );

        try {

          final response = await InstructorTodaysMocktestApiService()
              .fetchTodaysMocktest(

            instructorId:
            event.instructorId,
          );

          emit(
            InstructorTodaysMocktestSuccess(

              todaysMocktestResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorTodaysMocktestFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}