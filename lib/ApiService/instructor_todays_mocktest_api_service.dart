
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_todays_mocktest_model/instructor_todays_mocktest_model.dart';

class InstructorTodaysMocktestApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/tdaymocklist";

  /// FETCH TODAY'S MOCKTEST LIST
  Future<InstructorTodaysMocktestModel> fetchTodaysMocktest({

    required String instructorId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "instractor_id":
          instructorId,
        },
      );

      print("📌 TODAY'S MOCKTEST API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData = jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200) {

        final model =
        InstructorTodaysMocktestModel
            .fromJson(jsonData);

        if (!model.success) {

          throw Exception(
            model.message,
          );
        }

        return model;

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