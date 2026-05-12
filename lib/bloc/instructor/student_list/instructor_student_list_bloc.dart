

import 'package:amar_driving_school/bloc/instructor/student_list/instructor_student_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_student_list_api_service.dart';
import 'instructor_student_list_state.dart';

class InstructorStudentListBloc extends Bloc<InstructorStudentListEvent, InstructorStudentListState> {

  InstructorStudentListBloc()
      : super(InstructorStudentListInitial(),) {

    on<FetchInstructorStudentList>(
          (event, emit) async {

        emit(
          InstructorStudentListLoading(),
        );

        try {

          final response =
          await InstructorStudentListApiService()
              .fetchStudentList(

            instructureId:
            event.instructureId,
          );

          emit(
            InstructorStudentListSuccess(
              studentListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorStudentListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}

