

import 'package:amar_driving_school/bloc/student/todays_mocktest_list/student_todays_mocktest_list_event.dart';
import 'package:amar_driving_school/bloc/student/todays_mocktest_list/student_todays_mocktest_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_todays_mocktest_api_service.dart';

class StudentTodaysMocktestListBloc extends Bloc<StudentTodaysMocktestListEvent, StudentTodaysMocktestListState> {

  StudentTodaysMocktestListBloc()
      : super(
    StudentTodaysMocktestListInitial(),
  ) {

    on<FetchStudentTodaysMocktestList>(
          (event, emit) async {

        emit(
          StudentTodaysMocktestListLoading(),
        );

        try {

          final response =
          await StudentTodaysMocktestListApiService()
              .fetchTodaysMocktestList(

            studentCode:
            event.studentCode,
          );

          emit(
            StudentTodaysMocktestListSuccess(

              todaysMocktestListResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            StudentTodaysMocktestListFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}