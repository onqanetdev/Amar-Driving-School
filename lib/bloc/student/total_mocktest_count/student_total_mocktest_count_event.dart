

abstract class StudentTotalMocktestCountEvent {}

class FetchStudentTotalMocktestCount
    extends StudentTotalMocktestCountEvent {

  final String userId;

  FetchStudentTotalMocktestCount({

    required this.userId,
  });
}