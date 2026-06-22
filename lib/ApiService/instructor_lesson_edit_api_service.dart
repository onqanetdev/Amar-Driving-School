

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_lesson_edit_model/instructor_lesson_edit_model.dart';



class UpdateLessonApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/updatelesson";

  /// API CALL
  Future<InstructorLessonEdit> updateLesson({

    required String userid,
    required String instructorid,
    required String startDate,
    required String startTime,
    required String duration,
    required String topicId,
    required String subtopicId,

  }) async {

    final url = Uri.parse(baseUrl);

    print("📌 UPDATE LESSON API");

    try {

      final response = await ApiHelper.post(
        url: baseUrl,
        body: {
          'userid': userid,
          'instructorid': instructorid,
          'start_date': startDate,
          'start_time': startTime,
          'duration': duration,
          'topic_id': topicId,
          'subtopic_id': subtopicId,
        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final decodedJson = jsonDecode(response.body);

      if (decodedJson['success'] == true) {

        return InstructorLessonEdit.fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }
    } catch (e) {
      print("🔥 API ERROR: $e");
      rethrow;
    }
  }
}