

import 'package:amar_driving_school/bloc/instructor/delete_student/instructor_student_delete_event.dart';
import 'package:amar_driving_school/bloc/instructor/delete_student/instructor_student_delete_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_student_delete_api_service.dart';

class InstructorStudentDeleteBloc extends Bloc<InstructorStudentDeleteEvent, InstructorStudentDeleteState> {

  final InstructorStudentDeleteApiService apiService = InstructorStudentDeleteApiService();

  InstructorStudentDeleteBloc()
      : super(
    InstructorStudentDeleteInitial(),
  ) {

    on<InstructorStudentDeleteTapped>(
          (event, emit) async {

        emit(
          InstructorStudentDeleteLoading(),
        );

        try {

          final response =
          await apiService.deleteStudent(

            instructorId:
            event.instructorId,

            studentId:
            event.studentId,
          );

          emit(
            InstructorStudentDeleteSuccess(

              deleteResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            InstructorStudentDeleteFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}