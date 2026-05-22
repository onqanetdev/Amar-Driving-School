
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_mocktest_delete_model/instructor_mocktest_delete_model.dart';

class InstructorMocktestDeleteApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Mocktest/deletelesson";

  /// DELETE MOCKTEST
  Future<InstructorMocktestDeleteModel> deleteMocktest({

    required String mockId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "mockid": mockId,
        },
      );

      print("📌 DELETE MOCKTEST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        return InstructorMocktestDeleteModel
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