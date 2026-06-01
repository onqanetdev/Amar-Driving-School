
class StudentMocktestListModel {

  final int status;
  final bool success;
  final String message;
  final List<StudentMocktestData> data;

  StudentMocktestListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentMocktestListModel.fromJson(
      Map<String, dynamic> json) {

    return StudentMocktestListModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => StudentMocktestData.fromJson(e),
      ).toList(),
    );
  }
}

class StudentMocktestData {

  final String? id;
  final String? userId;
  final String? name;
  final String? classDate;
  final String? lessonStart;
  final dynamic lessonEnd;
  final String? duration;
  final String? topicId;
  final String? subtopicId;
  final String? rating;
  final String? instructorId;
  final String? status;
  final String? studentName;
  final String? email;
  final String? subtopicNames;

  StudentMocktestData({

    this.id,
    this.userId,
    this.name,
    this.classDate,
    this.lessonStart,
    this.lessonEnd,
    this.duration,
    this.topicId,
    this.subtopicId,
    this.rating,
    this.instructorId,
    this.status,
    this.studentName,
    this.email,
    this.subtopicNames,
  });

  factory StudentMocktestData.fromJson(
      Map<String, dynamic> json) {

    return StudentMocktestData(

      id: json['id'],

      userId:
      json['user_id']?.toString(),

      name: json['name'],

      classDate:
      json['class_date'],

      lessonStart:
      json['lesson_start'],

      lessonEnd:
      json['lesson_end'],

      duration:
      json['duration'],

      topicId:
      json['topic_id']?.toString(),

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