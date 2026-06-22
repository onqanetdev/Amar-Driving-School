

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_student_update_model/instructor_student_update_model.dart';

class InstructorStudentUpdateApiService {

  static const String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/studentdtlupdate";

  static Future<InstructorStudentUpdateModel>
  updateStudent({
    required String userId,
    required String name,
    required String age,
    required String startDate,
    required String phone,
    required String duration,
    required String price,
    required String paymentStatus,

  }) async {

    try {

      print("📌 Update Student API");
      print("📌 Request Body =>");
      print({
        "userid": userId,
        "name": name,
        "age": age,
        "startdate": startDate,
        "phone": phone,
        "duration": duration,
        "price": price,
        "paymentstatus": paymentStatus,
      });

      final response = await ApiHelper.post(
        //Uri.parse(apiUrl),
        url: apiUrl,
        body: {
          "userid": userId,
          "name": name,
          "age": age,
          "startdate": startDate,
          "phone": phone,
          "duration": duration,
          "price": price,
          "paymentstatus": paymentStatus,
        },
      )
          .timeout(
        const Duration(seconds: 30),
      );

      print("📌 STATUS CODE: ${response.statusCode}");
      print("📌 RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return InstructorStudentUpdateModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception(
          "Failed to update student. Status Code: ${response.statusCode}",
        );
      }

    } catch (e, stackTrace) {

      print("🔥 API ERROR: $e");
      print("🔥 STACKTRACE: $stackTrace");

      rethrow;
    }
  }
}