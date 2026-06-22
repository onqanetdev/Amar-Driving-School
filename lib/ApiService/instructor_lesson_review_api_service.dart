

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_lesson_review/instructor_lesson_review_model.dart';

class InstructorLessonReviewApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/lessonreview";

  /// SUBMIT LESSON REVIEW
  Future<InstructorLessonReviewModel> submitLessonReview({

    required String instructorId,

    required String studentId,

    required String topicId,

    required List<Map<String, dynamic>>
    ratingsData,

  }) async {

    try {

      final body = {

        "instractorid": instructorId,

        "studentid": studentId,

        "topicid": topicId,

        "ratings_data": ratingsData,
      };

      print("📌 LESSON REVIEW BODY");

      print(jsonEncode(body));

      final response = await http.post(

        Uri.parse(apiUrl),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode(body),
      );

      print("📌 LESSON REVIEW API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData =
      jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200 &&
          jsonData['success'] == true) {

        return InstructorLessonReviewModel
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


