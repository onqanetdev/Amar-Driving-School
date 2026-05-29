

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_lesson_review.dart';

class StudentLessonReviewApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/lessonreviewlist";

  /// FETCH LESSON REVIEW
  Future<StudentLessonReview> fetchLessonReview({

    required String studentCode,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "stdnt_code": studentCode,
        },
      );

      print("📌 FETCH LESSON REVIEW API");

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

        return StudentLessonReview.fromJson(jsonData);

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