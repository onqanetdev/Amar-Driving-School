

abstract class InstructorTodaysMocktestEvent {}

class FetchInstructorTodaysMocktest extends InstructorTodaysMocktestEvent {

  final String instructorId;

  FetchInstructorTodaysMocktest({

    required this.instructorId,
  });
}