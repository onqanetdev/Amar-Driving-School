

class StudentTodaysMocktestList {

  final int status;
  final bool success;
  final String message;
  final List<StudentTodaysMocktestData> data;

  StudentTodaysMocktestList({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentTodaysMocktestList.fromJson(
      Map<String, dynamic> json) {

    return StudentTodaysMocktestList(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) =>
            StudentTodaysMocktestData
                .fromJson(e),
      ).toList(),
    );
  }
}

class StudentTodaysMocktestData {

  final String? id;
  final String? userId;
  final String? name;
  final String? classDate;
  final String? lessonStart;
  final dynamic lessonEnd;
  final String? duration;
  final String? topicId;
  final String? subtopicId;
  final dynamic rating;
  final String? instructorId;
  final String? status;

  StudentTodaysMocktestData({

    required this.id,
    required this.userId,
    required this.name,
    required this.classDate,
    required this.lessonStart,
    required this.lessonEnd,
    required this.duration,
    required this.topicId,
    required this.subtopicId,
    required this.rating,
    required this.instructorId,
    required this.status,
  });

  factory StudentTodaysMocktestData.fromJson(
      Map<String, dynamic> json) {

    return StudentTodaysMocktestData(

      id: json['id'],

      userId: json['user_id'],

      name: json['name'],

      classDate: json['class_date'],

      lessonStart: json['lesson_start'],

      lessonEnd: json['lesson_end'],

      duration: json['duration'],

      topicId: json['topic_id'],

      subtopicId:
      json['subtopic_id'],

      rating: json['rating'],

      instructorId:
      json['instructor_id'],

      status: json['status'],
    );
  }
}