

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_lesson_detail_model/instructor_lesson_detail_model.dart';

class InstructorLessonDetailApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/lessondetail";

  /// FETCH LESSON DETAIL
  Future<InstructorLessonDetailModel> fetchLessonDetail({

    required String lessonId,

  }) async {

    try {

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
        body: {

          "lessonid": lessonId,
        },
      );

      print("📌 LESSON DETAIL API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return InstructorLessonDetailModel
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