

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_lesson_list_model.dart';

class StudentLessonListApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/lessonlist";

  /// FETCH LESSON LIST
  Future<StudentLessonListModel> fetchLessonList({

    required String studentId,
    required String limit,
    required String offset,

  }) async {

    try {

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
        body: {

          "studentid": studentId,
          "limit": limit,
          "offset": offset,
        },
      );

      print("📌 FETCH LESSON LIST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return StudentLessonListModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
        );
      }

    } catch (e, stackTrace) {

      print("🔥 API ERROR: $e");

      print(
        "🔥 STACKTRACE: $stackTrace",
      );

      rethrow;
    }
  }
}