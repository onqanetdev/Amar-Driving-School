
class StudentRealLessonReviewListModel {

  final int status;
  final bool success;
  final String message;
  final List<LessonReviewData> data;

  StudentRealLessonReviewListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentRealLessonReviewListModel.fromJson(
      Map<String, dynamic> json) {

    return StudentRealLessonReviewListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => LessonReviewData.fromJson(e),
      ).toList(),
    );
  }
}

class LessonReviewData {

  final String topicName;
  final String avgRating;
  final List<LessonReviewSubtopic> subtopics;

  LessonReviewData({

    required this.topicName,
    required this.avgRating,
    required this.subtopics,
  });

  factory LessonReviewData.fromJson(
      Map<String, dynamic> json) {

    return LessonReviewData(

      topicName:
      json['topic_name'] ?? "",

      avgRating: json['avg_rating'].toString(),

      subtopics:
      (json['subtopics'] as List)
          .map(
            (e) =>
            LessonReviewSubtopic
                .fromJson(e),
      )
          .toList(),
    );
  }
}

class LessonReviewSubtopic {

  final String subtopicName;
  final String rating;
  final String classDate;

  LessonReviewSubtopic({

    required this.subtopicName,
    required this.rating,
    required this.classDate,
  });

  factory LessonReviewSubtopic.fromJson(
      Map<String, dynamic> json) {

    return LessonReviewSubtopic(

      subtopicName:
      json['subtopic_name'] ?? "",

      rating:
      json['rating'] ?? "",

      classDate:
      json['class_date'] ?? "",
    );
  }
}