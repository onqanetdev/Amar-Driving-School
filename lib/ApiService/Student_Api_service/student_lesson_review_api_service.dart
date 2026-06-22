

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_lesson_review.dart';

class StudentLessonReviewApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/lessonreviewlist";

  /// FETCH LESSON REVIEW
  Future<StudentLessonReview> fetchLessonReview({

    required String studentCode,

  }) async {

    try {

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
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
      if(response.statusCode == 200) {

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