
abstract class InstructorMocktestDeleteEvent {}

class DeleteInstructorMocktest
    extends InstructorMocktestDeleteEvent {

  final String mockId;

  DeleteInstructorMocktest({

    required this.mockId,
  });
}