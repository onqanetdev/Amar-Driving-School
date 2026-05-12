class LessonModel {
  final String name;
  final String? topic;
  final String date;
  final String? time;
  final String? duration;

  LessonModel({
    required this.name,
    this.topic,
    required this.date,
    this.time,
    this.duration,
  });
}