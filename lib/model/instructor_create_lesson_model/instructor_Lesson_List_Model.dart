
class InstructorLessonListModel {

  final int status;
  final bool success;
  final String message;
  final List<LessonData> data;

  InstructorLessonListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorLessonListModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorLessonListModel(

      status: json['status'],
      success: json['success'],
      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => LessonData.fromJson(e),
      ).toList(),
    );
  }
}

class LessonData {

  final String lessonId;
  final String userId;
  final String name;
  final String classDate;
  final String? lessonStart;
  final dynamic lessonEnd;
  final dynamic pickupAddress;
  final dynamic classResult;
  final dynamic lessonWisePaymentMode;
  final String lessonDuration;
  final String topicId;
  final String subtopicId;
  final dynamic rating;
  final String instructorId;
  final String status;
  final String subtopic_names;

  LessonData({

    required this.lessonId,
    required this.userId,
    required this.name,
    required this.classDate,
    required this.lessonStart,
    required this.lessonEnd,
    required this.pickupAddress,
    required this.classResult,
    required this.lessonWisePaymentMode,
    required this.lessonDuration,
    required this.topicId,
    required this.subtopicId,
    required this.rating,
    required this.instructorId,
    required this.status,
    required this.subtopic_names
  });

  factory LessonData.fromJson(
      Map<String, dynamic> json) {

    return LessonData(

      lessonId: json['lesson_id'],
      userId: json['user_id'],
      name: json['name'],
      classDate: json['class_date'],
      lessonStart: json['lesson_start'],
      lessonEnd: json['lesson_end'],
      pickupAddress: json['pickup_address'],
      classResult: json['class_result'],
      lessonWisePaymentMode:
      json['lesson_wise_payment_mode'],
      lessonDuration:
      json['lesson_duration'],
      topicId: json['topic_id'],
      subtopicId: json['subtopic_id'],
      rating: json['rating'],
      instructorId: json['instructor_id'],
      status: json['status'],
        subtopic_names: json['subtopic_names']
    );
  }
}