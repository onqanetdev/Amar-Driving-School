

import 'package:amar_driving_school/bloc/student/total_mocktest_count/student_total_mocktest_count_event.dart';
import 'package:amar_driving_school/bloc/student/total_mocktest_count/student_total_mocktest_count_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_total_mocktest_list_api_service.dart';

class StudentTotalMocktestCountBloc extends Bloc<StudentTotalMocktestCountEvent, StudentTotalMocktestCountState> {

  StudentTotalMocktestCountBloc()
      : super(
    StudentTotalMocktestCountInitial(),
  ) {

    on<FetchStudentTotalMocktestCount>(
          (event, emit) async {

        emit(
          StudentTotalMocktestCountLoading(),
        );

        try {

          final response = await StudentTotalMocktestCountApiService().fetchTotalMocktestCount(
            userId:
            event.userId,
          );

          emit(
            StudentTotalMocktestCountSuccess(

              totalMocktestCountResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            StudentTotalMocktestCountFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}