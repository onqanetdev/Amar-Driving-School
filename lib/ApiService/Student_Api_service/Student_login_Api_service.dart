

import 'dart:convert';

import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:amar_driving_school/model/student_login/student_login_res_model.dart';
import 'package:http/http.dart' as http;

class StudentLoginApiService {
  //Url String
  final String baseUrl = "https://amardrivingcrm.com/Beta/api/Auth/studentlogin";
  //Parsing
  Future<StudentLoginResModel> loginAhead(String loginId) async {
    // converting url string to url
    final url = Uri.parse(baseUrl);
    print('Logged In');
    try {
      final response = await ApiHelper.post(
          //url,
        url: baseUrl,
          body: {
            'loginid': loginId
          }
      );
      print('Raw response: ${response.body}');
      // now the decoding
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return StudentLoginResModel.fromJson(decodedJson);
      } else {
        throw Exception("Student Logged in: ${response.body}");
      }
    } catch(e) {
      throw Exception("Loading Problem: $e");
    }
  }
}
