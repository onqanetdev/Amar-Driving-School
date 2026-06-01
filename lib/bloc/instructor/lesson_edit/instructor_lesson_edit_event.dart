
abstract class InstructorLessonEditEvent {}

class InstructorLessonEditTapped
    extends InstructorLessonEditEvent {

  final String userid;
  final String instructorid;
  final String startDate;
  final String startTime;
  final String duration;
  final String topicId;
  final String subtopicId;

  InstructorLessonEditTapped({

    required this.userid,
    required this.instructorid,
    required this.startDate,
    required this.startTime,
    required this.duration,
    required this.topicId,
    required this.subtopicId,
  });
}
