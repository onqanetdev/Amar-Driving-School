

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_update_mocktest_model/instructor_update_mocktest_model.dart';

class MocktestUpdateApiService {

  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Mocktest/updatemock";

  Future<InstructorUpdateMocktestModel> updateMocktest({

    required String userid,
    required String instructorid,
    required String startDate,
    required String startTime,
    required String duration,
    required String topicId,
    required String subtopicId,

  }) async {

    try {

      print("📌 UPDATE MOCKTEST API");

      final response = await ApiHelper.post(
        url: baseUrl,
        body: {

          "userid": userid,

          "instructorid": instructorid,

          "start_date": startDate,

          "start_time": startTime,

          "duration": duration,

          "topic_id": topicId,

          "subtopic_id": subtopicId,
        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final decodedJson = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return InstructorUpdateMocktestModel
            .fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'] ??
              'Failed to update mocktest',
        );
      }

    } catch (e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}