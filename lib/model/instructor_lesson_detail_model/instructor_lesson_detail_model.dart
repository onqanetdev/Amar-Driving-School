
class InstructorLessonDetailModel {

  final int status;
  final bool success;
  final String message;
  final LessonDetailData data;

  InstructorLessonDetailModel({

    required this.status,

    required this.success,

    required this.message,

    required this.data,
  });

  factory InstructorLessonDetailModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorLessonDetailModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: LessonDetailData.fromJson(
        json['data'],
      ),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data.toJson(),
    };
  }
}

class LessonDetailData {

  final String lessonId;
  final String userId;
  final String name;
  final String classDate;
  final dynamic lessonStart;
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

  LessonDetailData({

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

  factory LessonDetailData.fromJson(
      Map<String, dynamic> json) {

    return LessonDetailData(

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

      instructorId:
      json['instructor_id'],

      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'lesson_id': lessonId,

      'user_id': userId,

      'name': name,

      'class_date': classDate,

      'lesson_start': lessonStart,

      'lesson_end': lessonEnd,

      'pickup_address': pickupAddress,

      'class_result': classResult,

      'lesson_wise_payment_mode':
      lessonWisePaymentMode,

      'lesson_duration':
      lessonDuration,

      'topic_id': topicId,

      'subtopic_id': subtopicId,

      'rating': rating,

      'instructor_id': instructorId,

      'status': status,
    };
  }
}