

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/student_all_model/student_download_file_model.dart';

class StudentDownloadTrainingReportApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/download_trainingreport";

  /// API CALL
  Future<InstructorDownloadFileModel> downloadTrainingReport({

    required String loginId,

  }) async {

    final url = Uri.parse(apiUrl);

    print("📌 DOWNLOAD TRAINING REPORT API");

    try {

      final response = await http.post(

        url,

        body: {

          'loginid': loginId,

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

        return InstructorDownloadFileModel.fromJson(
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