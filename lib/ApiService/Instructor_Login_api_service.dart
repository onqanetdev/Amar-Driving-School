

import 'dart:convert';

import 'package:amar_driving_school/model/instructor_login/instructor_login_model.dart';
import 'package:http/http.dart' as http;

class InstructorLoginApiService {
  //Url String
  final String baseUrl = "https://amardrivingcrm.com/Beta/api/Auth/login";
  //Parsing
  Future<InstructorLoginModel> loginAhead( String instrucEmail,  String passWord) async {
    // converting url string to url
    final url = Uri.parse(baseUrl);
    print('Logged In');
    try {
      final response = await http.post( url,
          body: {
            'email': instrucEmail,
            'password': passWord
          }
      );
      print('Raw response: ${response.body}');
      // now the decoding
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return InstructorLoginModel.fromJson(decodedJson);
      } else {
        throw Exception("instructor Logged in: ${response.body}");
      }
    } catch(e) {
      throw Exception("Loading Problem: $e");
    }
  }
}