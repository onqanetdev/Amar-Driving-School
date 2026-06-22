

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_create_lesson_model/instructor_Lesson_List_Model.dart';

class InstructorLessonListApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/lessonlist";

  /// API CALL
  Future<InstructorLessonListModel>
  fetchLessonList({

    required String instructorId,
    required String limit,
    required String offset,

  }) async {

    final url = Uri.parse(baseUrl);

    print("📌 Fetch Lesson List");

    try {

      final response = await ApiHelper.post(
        url: baseUrl,
        body: {

          'instractorid': instructorId,
          'limit': limit,
          'offset': offset,

        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      /// 🔥 DECODE JSON
      final decodedJson =
      jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(decodedJson['success'] == true) {

        return InstructorLessonListModel
            .fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }

    } catch(e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}