

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_real_lesson_review_list_model.dart';

class StudentRealLessonReviewApiService {

  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Student/lessonreviewlist";

  Future<StudentRealLessonReviewListModel> fetchLessonReviewList({

    required String studentCode,
    required String topicId,

  }) async {

    try {

      print("📌 FETCH LESSON REVIEW LIST API");

      final response = await http.post(

        Uri.parse(baseUrl),

        body: {

          "stdnt_code": studentCode,

          "topic_id": topicId,
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

        if (decodedJson['success'] == true) {

          return StudentRealLessonReviewListModel
              .fromJson(decodedJson);

        } else {

          throw Exception(
            decodedJson['message'],
          );
        }

      } else {

        throw Exception(
          "Something went wrong!",
        );
      }

    } catch (e, stackTrace) {

      print(
        "🔥 API ERROR: $e",
      );

      print(
        "🔥 STACKTRACE: $stackTrace",
      );

      rethrow;
    }
  }
}