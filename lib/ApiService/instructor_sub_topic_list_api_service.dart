

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;

import '../model/instructor_topic/instructor_sub_topic_list_model.dart';

class InstructorSubTopicListApiService {

  /// URL
  final String baseUrl =
      "https://amardrivingcrm.com/Beta/api/Lesson/subtopiclist";

  /// API CALL
  Future<InstructorSubTopicListModel>
  fetchSubTopicList({

    required String topicId,

  }) async {

    final url = Uri.parse(baseUrl);

    print("📌 Fetch Sub Topic List");

    try {

      final response = await ApiHelper.post(
        url: baseUrl,
        body: {

          'topicid': topicId,

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
      if(decodedJson['success'] == true) {

        return InstructorSubTopicListModel
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