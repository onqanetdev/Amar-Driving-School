

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_create_mocktest/instructor_mocktest_list_model.dart';

class InstructorMocktestListApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Mocktest/mocktestlist";

  /// FETCH MOCKTEST LIST
  Future<InstructorMocktestListModel>
  fetchMocktestList({

    required String instructorId,

    required String limit,

    required String offset,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "instractorid": instructorId,

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

      /// SUCCESS
      if(response.statusCode == 200 &&
          jsonData['success'] == true) {

        return InstructorMocktestListModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
        );
      }

    } catch(e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}