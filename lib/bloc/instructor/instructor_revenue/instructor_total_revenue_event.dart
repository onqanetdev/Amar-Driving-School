

abstract class InstructorTotalRevenueEvent {}

class FetchInstructorTotalRevenue
    extends InstructorTotalRevenueEvent {

  final String instructorId;

  FetchInstructorTotalRevenue({

    required this.instructorId,
  });
}