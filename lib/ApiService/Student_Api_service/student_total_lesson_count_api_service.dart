


import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_total_lesson_count.dart';

class StudentTotalLessonCountApiService {

  /// API URL
  final String apiUrl = "https://amardrivingcrm.com/Beta/api/Student/lessoncount";

  /// FETCH TOTAL LESSON COUNT
  Future<StudentTotalLessonCount> fetchTotalLessonCount({

    required String userId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "userid": userId,
        },
      );

      print("📌 FETCH LESSON COUNT API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200 &&
          jsonData['success'] == true) {

        return StudentTotalLessonCount
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