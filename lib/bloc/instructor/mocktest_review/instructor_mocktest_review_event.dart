

abstract class InstructorMocktestReviewEvent {}

class SubmitInstructorMocktestReview extends InstructorMocktestReviewEvent {

  final String instructorId;

  final String studentId;

  final String topicId;

  final List<Map<String, dynamic>>
  ratingsData;

  SubmitInstructorMocktestReview({

    required this.instructorId,

    required this.studentId,

    required this.topicId,

    required this.ratingsData,
  });
}