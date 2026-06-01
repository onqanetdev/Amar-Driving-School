
class StudentMocktestReviewModel {

  final int status;
  final bool success;
  final String message;
  final List<MocktestReviewData> data;

  StudentMocktestReviewModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentMocktestReviewModel.fromJson(
      Map<String, dynamic> json) {

    return StudentMocktestReviewModel(

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
  final List<MocktestReviewSubtopic> subtopics;

  MocktestReviewData({

    required this.topicName,
    required this.subtopics,
  });

  factory MocktestReviewData.fromJson(
      Map<String, dynamic> json) {

    return MocktestReviewData(

      topicName: json['topic_name'] ?? "",

      subtopics:
      (json['subtopics'] as List)
          .map(
            (e) =>
            MocktestReviewSubtopic
                .fromJson(e),
      ).toList(),
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
      json['rating'] ?? "N/A",

      classDate:
      json['class_date'] ?? "",
    );
  }
}