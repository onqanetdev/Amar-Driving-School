

import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_list_event.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_mocktest_list_api_service.dart';

class InstructorMocktestListBloc extends Bloc<InstructorMocktestListEvent, InstructorMocktestListState> {

  InstructorMocktestListBloc() : super(InstructorMocktestListInitial(),) {

    on<FetchInstructorMocktestList>(
          (event, emit) async {

        emit(
          InstructorMocktestListLoading(),
        );

        try {

          final response =
          await InstructorMocktestListApiService()
              .fetchMocktestList(

            instructorId:
            event.instructorId,

            limit:
            event.limit,

            offset:
            event.offset,
          );

          emit(
            InstructorMocktestListSuccess(

              mocktestListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorMocktestListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}