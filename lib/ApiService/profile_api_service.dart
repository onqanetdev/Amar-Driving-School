

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/profile_model.dart';

class ProfileApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/User/profile";

  /// FETCH PROFILE
  Future<InstructorProfileModel>
  fetchProfile({

    required String userId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "userid": userId,
        },
      );

      print("📌 PROFILE API");

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

        return InstructorProfileModel
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