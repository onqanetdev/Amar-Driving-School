
import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_reset_password_model/instructor_reset_password_model.dart';

class InstructorResetPasswordApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Auth/resetpass";

  /// API CALL
  Future<InstructorResetPasswordModel> resetPassword({

    required String userId,
    required String otp,
    required String newPassword,

  }) async {

    final url = Uri.parse(apiUrl);

    print("📌 RESET PASSWORD API");

    try {

      final response = await ApiHelper.post(

       url:  apiUrl,

        body: {

          'userid': userId,
          'otp': otp,
          'newpass': newPassword,

        },
      );

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      /// 🔥 DECODE JSON
      final decodedJson = jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if (decodedJson['success'] == true) {

        return InstructorResetPasswordModel.fromJson(
          decodedJson,
        );

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }

    } catch (e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}