

import 'package:amar_driving_school/bloc/instructor/instructor_revenue/instructor_total_revenue_event.dart';
import 'package:amar_driving_school/bloc/instructor/instructor_revenue/instructor_total_revenue_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Instructor_Revenue_Api_Service.dart';

class InstructorTotalRevenueBloc extends Bloc<InstructorTotalRevenueEvent, InstructorTotalRevenueState> {

  InstructorTotalRevenueBloc() : super(InstructorTotalRevenueInitial(),) {

    on<FetchInstructorTotalRevenue>(
          (event, emit) async {

        emit(
          InstructorTotalRevenueLoading(),
        );

        try {

          final response =
          await InstructorTotalRevenueApiService()
              .fetchTotalRevenue(

            instructorId:
            event.instructorId,
          );

          emit(
            InstructorTotalRevenueSuccess(

              totalRevenueResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorTotalRevenueFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}