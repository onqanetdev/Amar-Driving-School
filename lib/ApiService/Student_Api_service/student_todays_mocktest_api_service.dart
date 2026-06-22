

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_todays_lesson_mocktest_list_model.dart';

class StudentTodaysMocktestListApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/tdaymocklist";

  /// FETCH TODAY'S MOCKTEST LIST
  Future<StudentTodaysMocktestList> fetchTodaysMocktestList({

    required String studentCode,

  }) async {

    try {

      final response = await ApiHelper.post(
       // Uri.parse(apiUrl),
        url: apiUrl,
        body: {

          "stdnt_code": studentCode,
        },
      );

      print("📌 FETCH TODAY'S MOCKTEST LIST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return StudentTodaysMocktestList
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