
class InstructorMocktestListModel {

  final int status;
  final bool success;
  final String message;
  final List<MocktestData> data;

  InstructorMocktestListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorMocktestListModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorMocktestListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => MocktestData.fromJson(e),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class MocktestData {

  final String id;
  final String userId;
  final String name;
  final String classDate;
  final String lessonStart;
  final dynamic lessonEnd;
  final String duration;
  final String topicId;
  final String subtopicId;
  final dynamic rating;
  final String instructorId;
  final String status;

  MocktestData({

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

  factory MocktestData.fromJson(
      Map<String, dynamic> json) {

    return MocktestData(

      id: json['id'],

      userId: json['user_id'],

      name: json['name'],

      classDate: json['class_date'],

      lessonStart: json['lesson_start'],

      lessonEnd: json['lesson_end'],

      duration: json['duration'],

      topicId: json['topic_id'],

      subtopicId: json['subtopic_id'],

      rating: json['rating'],

      instructorId: json['instructor_id'],

      status: json['status'],
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