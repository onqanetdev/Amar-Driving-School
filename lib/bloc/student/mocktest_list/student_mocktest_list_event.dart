
abstract class StudentMocktestListEvent {}

class FetchStudentMocktestList
    extends StudentMocktestListEvent {

  final String studentId;
  final String limit;
  final String offset;

  FetchStudentMocktestList({

    required this.studentId,
    required this.limit,
    required this.offset,
  });
}