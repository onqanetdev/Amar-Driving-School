

abstract class StudentTodaysMocktestListEvent {}

class FetchStudentTodaysMocktestList
    extends StudentTodaysMocktestListEvent {

  final String studentCode;

  FetchStudentTodaysMocktestList({

    required this.studentCode,
  });
}