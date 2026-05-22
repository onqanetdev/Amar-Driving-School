


import 'package:amar_driving_school/bloc/instructor/mocktest_delete/instructor_mocktest_delete_event.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_delete/instructor_mocktest_delete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_mocktest_delete_api_service.dart';

class InstructorMocktestDeleteBloc extends Bloc<InstructorMocktestDeleteEvent, InstructorMocktestDeleteState> {

  InstructorMocktestDeleteBloc()
      : super(
    InstructorMocktestDeleteInitial(),
  ) {

    on<DeleteInstructorMocktest>(
          (event, emit) async {

        emit(
          InstructorMocktestDeleteLoading(),
        );

        try {

          final response = await InstructorMocktestDeleteApiService().deleteMocktest(

            mockId:
            event.mockId,
          );

          emit(
            InstructorMocktestDeleteSuccess(

              deleteResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorMocktestDeleteFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}