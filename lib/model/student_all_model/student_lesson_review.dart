

class StudentLessonReview {

  final int status;
  final bool success;
  final String message;
  final List<LessonReviewData> data;

  StudentLessonReview({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentLessonReview.fromJson(
      Map<String, dynamic> json) {

    return StudentLessonReview(

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

  final String? topicName;
  final List<LessonSubtopic> subtopics;

  LessonReviewData({
    required this.topicName,
    required this.subtopics,
  });

  factory LessonReviewData.fromJson(
      Map<String, dynamic> json) {

    return LessonReviewData(

      topicName: json['topic_name'],

      subtopics: (json['subtopics'] as List)
          .map(
            (e) => LessonSubtopic.fromJson(e),
      ).toList(),
    );
  }
}

class LessonSubtopic {

  final String? subtopicName;

  final String? rating;

  final String? classDate;

  LessonSubtopic({

    required this.subtopicName,

    required this.rating,

    required this.classDate,
  });

  factory LessonSubtopic.fromJson(
      Map<String, dynamic> json) {

    return LessonSubtopic(

      subtopicName:
      json['subtopic_name'],

      rating:
      json['rating'],

      classDate:
      json['class_date'],
    );
  }
}