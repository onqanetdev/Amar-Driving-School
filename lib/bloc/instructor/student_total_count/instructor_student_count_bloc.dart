
import 'package:amar_driving_school/bloc/instructor/student_total_count/instructor_student_count_event.dart';
import 'package:amar_driving_school/bloc/instructor/student_total_count/instructor_studentcount_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_studentCount_Api_service.dart';

class InstructorStudentCountBloc extends Bloc<
    InstructorStudentCountEvent,
    InstructorStudentCountState> {

  InstructorStudentCountBloc()
      : super(
    InstructorStudentCountInitial(),
  ) {

    on<FetchInstructorStudentCount>(
          (event, emit) async {

        emit(
          InstructorStudentCountLoading(),
        );

        try {

          final response =
          await InstructorStudentCountApiService()
              .fetchTotalStudent(

            instructorId:
            event.instructorId,
          );

          emit(
            InstructorStudentCountSuccess(

              totalStudentResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorStudentCountFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}