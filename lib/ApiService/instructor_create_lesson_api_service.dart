

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_create_lesson_model/instructor_create_lesson_model.dart';

class CreateLessonApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/createlesson";

  /// API CALL
  Future<InstructorCreateLessonModel>
  createLesson({

    required String userid,
    required String instructorid,
    //required String name,
    required String startDate,
    required String startTime,
    required String duration,
    required String topicId,
    required String subtopicId,

  }) async {

    final url = Uri.parse(baseUrl);

    print("📌 Create Lesson API");

    try {

      final response = await ApiHelper.post(

        url: baseUrl,

        body: {

          'userid': userid,
          'instructorid': instructorid,
          //'name': name,
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

      /// 🔥 DECODE JSON
      final decodedJson =
      jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(decodedJson['success'] == true) {

        return InstructorCreateLessonModel.fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }

    } catch(e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}