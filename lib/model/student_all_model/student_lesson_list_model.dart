


class StudentLessonListModel {

  final int status;
  final bool success;
  final String message;
  final List<StudentLessonData> data;

  StudentLessonListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentLessonListModel.fromJson(
      Map<String, dynamic> json) {

    return StudentLessonListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => StudentLessonData.fromJson(e),
      ).toList(),
    );
  }
}

class StudentLessonData {

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
  final String? rating;
  final String? instructorId;
  final String? status;
  final String? studentName;
  final String? email;
  final String? subtopicNames;

  StudentLessonData({

    this.lessonId,
    this.userId,
    this.name,
    this.classDate,
    this.lessonStart,
    this.lessonEnd,
    this.pickupAddress,
    this.classResult,
    this.lessonWisePaymentMode,
    this.lessonDuration,
    this.topicId,
    this.subtopicId,
    this.rating,
    this.instructorId,
    this.status,
    this.studentName,
    this.email,
    this.subtopicNames,
  });

  factory StudentLessonData.fromJson(
      Map<String, dynamic> json) {

    return StudentLessonData(

      lessonId: json['lesson_id'],

      userId: json['user_id']?.toString(),

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

      topicId: json['topic_id']?.toString(),

      subtopicId:
      json['subtopic_id']?.toString(),

      rating:
      json['rating']?.toString(),

      instructorId:
      json['instructor_id']?.toString(),

      status:
      json['status']?.toString(),

      studentName:
      json['student_name'],

      email:
      json['email'],

      subtopicNames:
      json['subtopic_names'],
    );
  }
}