

abstract class InstructorMocktestListEvent {}

class FetchInstructorMocktestList
    extends InstructorMocktestListEvent {

  final String instructorId;
  final String limit;
  final String offset;

  FetchInstructorMocktestList({

    required this.instructorId,

    required this.limit,

    required this.offset,
  });
}