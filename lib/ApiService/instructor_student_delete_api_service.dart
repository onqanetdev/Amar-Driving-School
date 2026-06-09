

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_student_delete/instructor_student_delete.dart';

class InstructorStudentDeleteApiService {

  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Home/deletestudent";

  Future<InstructorStudentDeleteModel> deleteStudent({

    required String instructorId,
    required String studentId,

  }) async {

    try {

      print("📌 DELETE STUDENT API");

      final response = await http.post(

        Uri.parse(baseUrl),

        body: {

          "instractorid": instructorId,

          "studentid": studentId,
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

          return InstructorStudentDeleteModel
              .fromJson(decodedJson);

        } else {

          throw Exception(
            decodedJson['message'] ??
                "Failed to delete student",
          );
        }

      } else {

        throw Exception(
          "Something went wrong! Status Code: ${response.statusCode}",
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