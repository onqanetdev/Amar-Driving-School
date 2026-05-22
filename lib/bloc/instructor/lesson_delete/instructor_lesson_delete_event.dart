
abstract class InstructorLessonDeleteEvent {}

class DeleteInstructorLesson extends InstructorLessonDeleteEvent {

  final String lessonId;

  DeleteInstructorLesson({

    required this.lessonId,
  });
}