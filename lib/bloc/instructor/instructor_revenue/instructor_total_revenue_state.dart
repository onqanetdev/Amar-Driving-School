

import '../../../model/instructor_revenue_model/instructor_revenue_res_model.dart';

abstract class InstructorTotalRevenueState {}

class InstructorTotalRevenueInitial
    extends InstructorTotalRevenueState {}

class InstructorTotalRevenueLoading
    extends InstructorTotalRevenueState {}

class InstructorTotalRevenueSuccess
    extends InstructorTotalRevenueState {

  final InstructorRevenueResModel totalRevenueResponse;

  InstructorTotalRevenueSuccess({

    required this.totalRevenueResponse,
  });
}

class InstructorTotalRevenueFailure
    extends InstructorTotalRevenueState {

  final String error;

  InstructorTotalRevenueFailure(
      this.error,
      );
}