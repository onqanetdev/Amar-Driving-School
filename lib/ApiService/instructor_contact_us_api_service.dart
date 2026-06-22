

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_contact_us_model/instructor_contact_us_form_model.dart';

class InstructorContactUsApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/support";

  /// CONTACT US API
  Future<InstructorContactUsFormModel> submitContactForm({

    required String firstName,

    required String lastName,

    required String email,

    required String contact,

    required String message,

  }) async {

    try {

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
        body: {

          "firstname": firstName,

          "lastname": lastName,

          "email": email,

          "contact": contact,

          "message": message,
        },
      );

      print("📌 CONTACT US API");

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

        return InstructorContactUsFormModel
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