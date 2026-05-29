

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_todays_lesson_list_model.dart';

class StudentTodaysLessonListApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/tdaylsnlist";

  /// FETCH TODAY'S LESSON LIST
  Future<StudentTodaysLessonListModel> fetchTodaysLessonList({

    required String studentCode,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "stdnt_code": studentCode,
        },
      );

      print("📌 FETCH TODAY'S LESSON LIST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return StudentTodaysLessonListModel
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