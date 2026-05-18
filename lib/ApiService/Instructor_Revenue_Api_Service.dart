

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_revenue_model/instructor_revenue_res_model.dart';

class InstructorTotalRevenueApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Home/totalrevenue";

  /// FETCH TOTAL REVENUE
  Future<InstructorRevenueResModel>
  fetchTotalRevenue({

    required String instructorId,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "instractor_id": instructorId,
        },
      );

      print("📌 Total Revenue API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      /// 🔥 DECODE JSON
      final jsonData = jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(response.statusCode == 200) {

        return InstructorRevenueResModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
        );
      }

    } catch (e) {

      print("🔥 API ERROR: $e");

      rethrow;
    }
  }
}