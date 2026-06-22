

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_todays_lesson_model/instructor_todays_lesson_model.dart';

class InstructorTodaysLessonApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/tdaylsnlist";

  /// FETCH TODAY'S LESSON LIST
  Future<InstructorTodaysLessonModel> fetchTodaysLesson({
    required String instructorId,
  }) async {

    try {

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
        body: {
          "instractor_id": instructorId,
        },
      );

      print("📌 TODAY'S LESSON API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        final model = InstructorTodaysLessonModel.fromJson(jsonData);

        if (model.success == true) {

          return model;

        } else {

          throw Exception(model.message);
        }

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