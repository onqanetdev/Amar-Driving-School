

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_real_mocktest_review_list_model.dart';

class StudentRealMocktestReviewApiService {

  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Student/mockreviewlist";

  Future<StudentRealMocktestReviewListModel>
  fetchMocktestReviewList({

    required String studentCode,
    required String topicId,

  }) async {

    try {

      print("📌 FETCH MOCKTEST REVIEW LIST API");

      final response = await ApiHelper.post(
        //Uri.parse(baseUrl),
        url: baseUrl,
        body: {

          "stdnt_code": studentCode,

          "topic_id": topicId,
        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final decodedJson = jsonDecode(response.body);

      if (response.statusCode == 200) {

        if (decodedJson['success'] == true) {

          return StudentRealMocktestReviewListModel.fromJson(decodedJson);

        } else {

          throw Exception(
            decodedJson['message'],
          );
        }

      } else {

        throw Exception(
          "Something went wrong!",
        );
      }

    } catch (e, stackTrace) {

      print(
        "🔥 API ERROR: $e",
      );

      print(
        "🔥 STACKTRACE: $stackTrace",
      );

      rethrow;
    }
  }
}