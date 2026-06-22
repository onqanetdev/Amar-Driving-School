
import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_student_add/instructor_student_add.dart';

class InstructorAddStudentApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Auth/addstudent";

  /// API CALL
  Future<InstructorStudentAddModel> addedStudent({

    required String name,
    required String age,
    required String startdate,
    required String email,
    required String duration,
    required String price,
    required String instructureid,
    required String paymentstatus,
    required String phone,

  }) async {

    final url = Uri.parse(baseUrl);

    print('Add Student');

    try {

      final response = await ApiHelper.post(
        url: baseUrl,
        body: {

          'name': name,
          'age': age,
          'startdate': startdate,
          'email': email,
          'duration': duration,
          'price': price,
          'instructureid': instructureid,
          'paymentstatus': paymentstatus,
          'phone': phone,

        },
      );

      print("STATUS CODE: ${response.statusCode}");

      print("RAW RESPONSE: ${response.body}");

      /// 🔥 DECODE RESPONSE
      final decodedJson = jsonDecode(response.body);

      /// 🔥 CHECK API SUCCESS
      if(decodedJson['success'] == true) {

        return InstructorStudentAddModel
            .fromJson(decodedJson);

      } else {

        String errorMessage = "Something went wrong";

        if (decodedJson['message'] is Map &&
            decodedJson['message']['email'] != null) {
          errorMessage = decodedJson['message']['email'].toString();
        }

        throw Exception(errorMessage);
      }

    } catch(e, stackTrace) {

      print("🔥 API ERROR: ${e}");

      print("🔥 STACKTRACE: $stackTrace");

      rethrow;
    }
  }
}