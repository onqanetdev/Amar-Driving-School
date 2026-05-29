

class StudentTodaysLessonListModel {

  final int status;
  final bool success;
  final String message;
  final List<StudentTodaysLessonData> data;

  StudentTodaysLessonListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentTodaysLessonListModel.fromJson(
      Map<String, dynamic> json) {

    return StudentTodaysLessonListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) =>
            StudentTodaysLessonData
                .fromJson(e),
      ).toList(),
    );
  }
}

class StudentTodaysLessonData {

  final String? lessonId;
  final String? userId;
  final String? name;
  final String? classDate;
  final String? lessonStart;
  final dynamic lessonEnd;
  final dynamic pickupAddress;
  final dynamic classResult;
  final dynamic lessonWisePaymentMode;
  final String? lessonDuration;
  final String? topicId;
  final String? subtopicId;
  final dynamic rating;
  final String? instructorId;
  final String? status;

  StudentTodaysLessonData({

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
  });

  factory StudentTodaysLessonData.fromJson(
      Map<String, dynamic> json) {

    return StudentTodaysLessonData(

      lessonId: json['lesson_id'],

      userId: json['user_id'],

      name: json['name'],

      classDate: json['class_date'],

      lessonStart: json['lesson_start'],

      lessonEnd: json['lesson_end'],

      pickupAddress:
      json['pickup_address'],

      classResult:
      json['class_result'],

      lessonWisePaymentMode:
      json['lesson_wise_payment_mode'],

      lessonDuration:
      json['lesson_duration'],

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