

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_forgot_password_model/instructor_forgot_password_model.dart';

class InstructorForgotPasswordApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Auth/forgetpass";

  /// API CALL
  Future<InstructorForgotPasswordModel>
  forgotPassword({

    required String email,

  }) async {

    final url = Uri.parse(apiUrl);

    print("📌 FORGOT PASSWORD API");

    try {

      final response = await ApiHelper.post(

        url: apiUrl,

        body: {

          "email": email,

        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      /// 🔥 DECODE JSON
      final decodedJson =
      jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(decodedJson['success'] == true) {

        return InstructorForgotPasswordModel.fromJson(
          decodedJson,
        );

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }

    } catch(e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}