

abstract class InstructorLessonDetailEvent {}

class FetchInstructorLessonDetail
    extends InstructorLessonDetailEvent {

  final String lessonId;

  FetchInstructorLessonDetail({

    required this.lessonId,
  });
}