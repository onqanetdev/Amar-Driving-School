
abstract class InstructorTodaysLessonEvent {}

class FetchInstructorTodaysLesson extends InstructorTodaysLessonEvent {

  final String instructorId;

  FetchInstructorTodaysLesson({

    required this.instructorId,
  });
}