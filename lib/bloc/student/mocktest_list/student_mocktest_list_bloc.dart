
import 'package:amar_driving_school/bloc/student/mocktest_list/student_mocktest_list_event.dart';
import 'package:amar_driving_school/bloc/student/mocktest_list/student_mocktest_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_mocktest_list_api_service.dart';

class StudentMocktestListBloc extends Bloc<StudentMocktestListEvent, StudentMocktestListState> {

  StudentMocktestListBloc()
      : super(
    StudentMocktestListInitial(),
  ) {

    on<FetchStudentMocktestList>(
          (event, emit) async {

        emit(
          StudentMocktestListLoading(),
        );

        try {

          final response = await StudentMocktestListApiService()
              .fetchMocktestList(

            studentId:
            event.studentId,

            limit:
            event.limit,

            offset:
            event.offset,
          );

          emit(
            StudentMocktestListSuccess(

              mocktestListResponse:
              response,
            ),
          );

        } catch (e) {

          emit(
            StudentMocktestListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}