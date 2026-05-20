

abstract class InstructorLessonReviewEvent {}

class SubmitInstructorLessonReview
    extends InstructorLessonReviewEvent {

  final String instructorId;

  final String studentId;

  final String topicId;

  final List<Map<String, dynamic>>
  ratingsData;

  SubmitInstructorLessonReview({

    required this.instructorId,

    required this.studentId,

    required this.topicId,

    required this.ratingsData,
  });
}