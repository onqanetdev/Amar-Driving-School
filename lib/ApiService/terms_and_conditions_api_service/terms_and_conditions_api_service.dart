

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/terms_and_Conditions_model.dart';

class TermsAndConditionsApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Page/pagedetail";

  /// FETCH TERMS & CONDITIONS
  Future<InstructorTermsConditionsModel>
  fetchTermsAndConditions({

    required String pageTitle,

  }) async {

    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        body: {

          "pagetitle": pageTitle,
        },
      );

      print("📌 TERMS & CONDITIONS API");

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      final jsonData =
      jsonDecode(response.body);

      /// SUCCESS
      if(response.statusCode == 200 &&
          jsonData['success'] == true) {

        return InstructorTermsConditionsModel
            .fromJson(jsonData);

      } else {

        throw Exception(
          jsonData['message'],
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