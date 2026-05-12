

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_student_list/instructor_student_list_model.dart';

class InstructorStudentListApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Student/studentlist";

  /// API CALL
  Future<InstructorStudentListModel> fetchStudentList({required String instructureId,}) async {

    final url = Uri.parse(baseUrl);

    print("📌 Fetch Student List");

    try {

      final response = await http.post(

        url,

        body: {

          'instructorid': instructureId,

        },
      );

      // print(
      //   "📌 STATUS CODE: ${response.statusCode}",
      // );
      //
      // print(
      //   "📌 RAW RESPONSE: ${response.body}",
      // );

      /// 🔥 DECODE JSON
      final decodedJson = jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(decodedJson['success'] == true) {

        return InstructorStudentListModel
            .fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'],
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