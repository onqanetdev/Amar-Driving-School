
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_lesson_delete_model/instructor_lesson_delete_model.dart';

class InstructorLessonDeleteApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/deletelesson";

  /// DELETE LESSON
  Future<InstructorLessonDeleteModel> deleteLesson({

    required String lessonId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "lessonid": lessonId,
        },
      );

      print("📌 DELETE LESSON API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return InstructorLessonDeleteModel
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