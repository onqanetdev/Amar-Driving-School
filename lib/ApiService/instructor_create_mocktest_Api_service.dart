

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_create_mocktest/instructor_create_mocktest_model.dart';

class InstructorCreateMocktestApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Mocktest/createmocktest";

  /// CREATE MOCKTEST
  Future<InstructorCreateMocktestModel> createMocktest({

    required String userid,
    required String instructorid,
   // required String name,
    required String startDate,
    required String startTime,
    required String duration,
    required String topicId,
    required String subtopicId,

  }) async {

    try {

      final response = await ApiHelper.post(
        url: apiUrl,
        body: {

          "userid": userid,

          "instructorid": instructorid,

          //"name": name,

          "start_date": startDate,

          "start_time": startTime,

          "duration": duration,

          "topic_id": topicId,

          "subtopic_id": subtopicId,
        },
      );

      print("📌 CREATE MOCKTEST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      if(response.statusCode == 200) {

        return InstructorCreateMocktestModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
        );
      }

    } catch(e, stackTrace) {

      print("🔥 API ERROR: $e");

      print(
        "🔥 STACKTRACE: $stackTrace",
      );

      rethrow;
    }
  }
}