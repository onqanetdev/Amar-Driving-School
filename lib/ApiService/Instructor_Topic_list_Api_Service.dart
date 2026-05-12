

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/instructor_topic/instructor_topic_list_model.dart';

class InstructorTopicListApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/topiclist";

  /// API CALL
  Future<InstructorTopicListModel> fetchTopicList() async {

    final url = Uri.parse(baseUrl);

    print("📌 Fetch Topic List");

    try {

      final response = await http.post(url);

      print(
        "📌 STATUS CODE: ${response.statusCode}",
      );

      print(
        "📌 RAW RESPONSE: ${response.body}",
      );

      /// 🔥 DECODE JSON
      final decodedJson = jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if(decodedJson['success'] == true) {

        return InstructorTopicListModel
            .fromJson(decodedJson);

      } else {

        throw Exception(
          decodedJson['message'],
        );
      }

    } catch(e) {

      print("🔥 API ERROR: $e");
      rethrow;
    }
  }
}