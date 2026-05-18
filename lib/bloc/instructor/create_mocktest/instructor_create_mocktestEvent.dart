

abstract class InstructorCreateMocktestEvent {}

class InstructorCreateMocktestTapped
    extends InstructorCreateMocktestEvent {

  final String userid;
  final String instructorid;
  final String name;
  final String startDate;
  final String startTime;
  final String duration;
  final String topicId;
  final String subtopicId;

  InstructorCreateMocktestTapped({

    required this.userid,

    required this.instructorid,

    required this.name,

    required this.startDate,

    required this.startTime,

    required this.duration,

    required this.topicId,

    required this.subtopicId,
  });
}