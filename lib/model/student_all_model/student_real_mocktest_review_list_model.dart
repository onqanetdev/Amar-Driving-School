

class StudentRealMocktestReviewListModel {

  final int status;
  final bool success;
  final String message;
  final List<MocktestReviewData> data;

  StudentRealMocktestReviewListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentRealMocktestReviewListModel.fromJson(
      Map<String, dynamic> json) {

    return StudentRealMocktestReviewListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => MocktestReviewData.fromJson(e),
      ).toList(),
    );
  }
}

class MocktestReviewData {

  final String topicName;
  final String avgRating;
  final List<MocktestReviewSubtopic> subtopics;

  MocktestReviewData({

    required this.topicName,
    required this.avgRating,
    required this.subtopics,
  });

  factory MocktestReviewData.fromJson(
      Map<String, dynamic> json) {

    return MocktestReviewData(

      topicName:
      json['topic_name'] ?? "",

      /// Handles both "N/A" and numeric values
      avgRating:
      json['avg_rating'].toString(),

      subtopics:
      (json['subtopics'] as List)
          .map(
            (e) =>
            MocktestReviewSubtopic
                .fromJson(e),
      )
          .toList(),
    );
  }
}

class MocktestReviewSubtopic {

  final String subtopicName;
  final String rating;
  final String classDate;

  MocktestReviewSubtopic({

    required this.subtopicName,
    required this.rating,
    required this.classDate,
  });

  factory MocktestReviewSubtopic.fromJson(
      Map<String, dynamic> json) {

    return MocktestReviewSubtopic(

      subtopicName:
      json['subtopic_name'] ?? "",

      rating:
      json['rating'] ?? "",

      classDate:
      json['class_date'] ?? "",
    );
  }
}