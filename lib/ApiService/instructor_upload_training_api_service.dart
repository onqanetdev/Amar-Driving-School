
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../helper/network_helper.dart';
import '../model/instructor_upload_training_report/instructor_upload_training_report.dart';

class InstructorUploadTrainingReportApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/upldcertificate";

  /// UPLOAD TRAINING REPORT
  // Future<InstructorUploadTrainingReport>
  // uploadTrainingReport({
  //
  //   required String studentId,
  //
  //   required String status,
  //
  //   required File reportFile,
  //
  // })
  //
  // async {
  //
  //
  //   try {
  //
  //     /// MULTIPART REQUEST
  //     var request = http.MultipartRequest(
  //
  //       "POST",
  //
  //       Uri.parse(apiUrl),
  //     );
  //
  //     /// BODY
  //     request.fields['student_id'] =
  //         studentId;
  //
  //     request.fields['status'] =
  //         status;
  //
  //     /// FILE
  //     request.files.add(
  //
  //       await http.MultipartFile
  //           .fromPath(
  //
  //         'report',
  //
  //         reportFile.path,
  //       ),
  //     );
  //
  //     print(
  //       "📌 UPLOAD TRAINING REPORT API",
  //     );
  //
  //     print(
  //       "📌 STUDENT ID: $studentId",
  //     );
  //
  //     print(
  //       "📌 STATUS: $status",
  //     );
  //
  //     print(
  //       "📌 FILE PATH: ${reportFile.path}",
  //     );
  //
  //     /// SEND REQUEST
  //     final streamedResponse =
  //     await request.send();
  //
  //     final response =
  //     await http.Response.fromStream(
  //       streamedResponse,
  //     );
  //
  //     print(
  //       "📌 STATUS CODE: ${response.statusCode}",
  //     );
  //
  //     print(
  //       "📌 RAW RESPONSE: ${response.body}",
  //     );
  //
  //     final jsonData = jsonDecode(response.body);
  //
  //     /// SUCCESS
  //     if(response.statusCode == 200) {
  //
  //       return InstructorUploadTrainingReport
  //           .fromJson(jsonData);
  //
  //     } else {
  //
  //       throw Exception(
  //         jsonData['message'],
  //       );
  //     }
  //
  //   } catch(e, stackTrace) {
  //
  //     print("🔥 API ERROR: $e");
  //
  //     print(
  //       "🔥 STACKTRACE: $stackTrace",
  //     );
  //
  //     rethrow;
  //   }
  // }


  Future<InstructorUploadTrainingReport>
  uploadTrainingReport({

    required String studentId,
    required String status,
    required File reportFile,

  }) async {

    try {

      /// INTERNET CHECK
      if (!await NetworkHelper.isInternetAvailable()) {
        throw Exception("No Internet Connection");
      }

      /// MULTIPART REQUEST
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(apiUrl),
      );

      request.fields['student_id'] = studentId;
      request.fields['status'] = status;

      request.files.add(
        await http.MultipartFile.fromPath(
          'report',
          reportFile.path,
        ),
      );

      print("📌 UPLOAD TRAINING REPORT API");
      print("📌 STUDENT ID: $studentId");
      print("📌 STATUS: $status");
      print("📌 FILE PATH: ${reportFile.path}");

      final streamedResponse =
      await request.send();

      final response =
      await http.Response.fromStream(
        streamedResponse,
      );

      print("📌 STATUS CODE: ${response.statusCode}");
      print("📌 RAW RESPONSE: ${response.body}");

      final jsonData =
      jsonDecode(response.body);

      if (response.statusCode == 200) {

        return InstructorUploadTrainingReport
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
        );
      }

    } catch (e, stackTrace) {

      print("🔥 API ERROR: $e");
      print("🔥 STACKTRACE: $stackTrace");

      rethrow;
    }
  }


}