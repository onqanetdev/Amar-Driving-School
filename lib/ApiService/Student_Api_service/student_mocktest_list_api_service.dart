

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_mocktest_list_model.dart';

class StudentMocktestListApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/mocklist";

  /// FETCH MOCKTEST LIST
  Future<StudentMocktestListModel>  fetchMocktestList({

    required String studentId,
    required String limit,
    required String offset,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "studentid": studentId,
          "limit": limit,
          "offset": offset,
        },
      );

      print("📌 FETCH MOCKTEST LIST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return StudentMocktestListModel
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