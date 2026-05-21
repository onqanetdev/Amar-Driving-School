

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_mocktest_review/instructor_mocktest_review_model.dart';

class InstructorMocktestReviewApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Mocktest/mocktestreview";

  /// SUBMIT MOCKTEST REVIEW
  Future<InstructorMocktestReviewModel>  submitMocktestReview({

    required String instructorId,

    required String studentId,

    required String topicId,

    required List<Map<String, dynamic>>
    ratingsData,

  }) async {

    try {

      final body = {

        "instractorid": instructorId,

        "studentid": studentId,

        "topicid": topicId,

        "ratings_data": ratingsData,
      };

      print("📌 MOCKTEST REVIEW BODY");

      print(jsonEncode(body));

      final response = await http.post(

        Uri.parse(apiUrl),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode(body),
      );

      print("📌 MOCKTEST REVIEW API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData =
      jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200 &&
          jsonData['success'] == true) {

        return InstructorMocktestReviewModel
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
