

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_create_lesson_model/Instructor_student_total_count.dart';

class InstructorStudentCountApiService {

  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/totalstudent";

  Future<InstructorStudentTotalCountModel>
  fetchTotalStudent({

    required String instructorId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "instractor_id": instructorId,
        },
      );

      print("📌 Total Student API");
      print("📌 STATUS CODE: ${response.statusCode}");
      print("📌 RAW RESPONSE: ${response.body}");

      if(response.statusCode == 200) {

        final jsonData =
        jsonDecode(response.body);

        return InstructorStudentTotalCountModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          "Failed to load total student count",
        );
      }

    } catch (e) {

      throw Exception(
        "API Error: $e",
      );
    }
  }
}