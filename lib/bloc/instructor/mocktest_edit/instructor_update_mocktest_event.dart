

abstract class InstructorUpdateMocktestEvent {}

class InstructorUpdateMocktestTapped extends InstructorUpdateMocktestEvent {

  final String userid;
  final String instructorid;
  final String startDate;
  final String startTime;
  final String duration;
  final String topicId;
  final String subtopicId;

  InstructorUpdateMocktestTapped({

    required this.userid,
    required this.instructorid,
    required this.startDate,
    required this.startTime,
    required this.duration,
    required this.topicId,
    required this.subtopicId,
  });
}