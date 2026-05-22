
class InstructorTodaysMocktestModel {

  final int status;
  final bool success;
  final String message;
  final List<TodaysMocktestData> data;

  InstructorTodaysMocktestModel({

    required this.status,

    required this.success,

    required this.message,

    required this.data,
  });

  factory InstructorTodaysMocktestModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorTodaysMocktestModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: List<TodaysMocktestData>.from(

        json['data'].map(

              (x) =>
              TodaysMocktestData.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data.map(
            (x) => x.toJson(),
      ).toList(),
    };
  }
}

class TodaysMocktestData {

  final String id;
  final String userId;
  final String name;
  final String classDate;
  final dynamic lessonStart;
  final dynamic lessonEnd;
  final String duration;
  final String topicId;
  final String subtopicId;
  final dynamic rating;
  final String instructorId;
  final String status;

  TodaysMocktestData({

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

  factory TodaysMocktestData.fromJson(
      Map<String, dynamic> json) {

    return TodaysMocktestData(

      id: json['id'],

      userId: json['user_id'],

      name: json['name'],

      classDate: json['class_date'],

      lessonStart:
      json['lesson_start'],

      lessonEnd:
      json['lesson_end'],

      duration:
      json['duration'],

      topicId:
      json['topic_id'],

      subtopicId:
      json['subtopic_id'],

      rating:
      json['rating'],

      instructorId:
      json['instructor_id'],

      status:
      json['status'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'user_id': userId,

      'name': name,

      'class_date': classDate,

      'lesson_start': lessonStart,

      'lesson_end': lessonEnd,

      'duration': duration,

      'topic_id': topicId,

      'subtopic_id': subtopicId,

      'rating': rating,

      'instructor_id': instructorId,

      'status': status,
    };
  }
}