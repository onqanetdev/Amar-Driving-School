

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_total_mocktest_count_model.dart';

class StudentTotalMocktestCountApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/mockcount";

  /// FETCH TOTAL MOCKTEST COUNT
  Future<StudentTotalMocktestCountModel>  fetchTotalMocktestCount({

    required String userId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "userid": userId,
        },
      );

      print("📌 FETCH MOCKTEST COUNT API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return StudentTotalMocktestCountModel
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