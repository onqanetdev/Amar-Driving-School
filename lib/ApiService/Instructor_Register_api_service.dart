

import 'dart:convert';

import 'package:amar_driving_school/model/instructor_register/instructor_register_model.dart';
import 'package:http/http.dart' as http ;

class InstructorRegisterApiService {
  //Url String
  final String baseUrl = "https://amardrivingcrm.com/Beta/api/Auth/reginstructor";
  //Parsing
  Future<InstructorRegisterModel> registerAhead(String instrucName, String instrucEmail, String phone, String passWord) async {
  // converting url string to url
  final url = Uri.parse(baseUrl);
  print('It is Getting registered');
  try {
    final response = await http.post( url,
      body: {
      'name': instrucName,
        'email': instrucEmail,
        'phone': phone,
        'password': passWord
      }
    );
    print('Raw response: ${response.body}');
    // now the decoding
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      return InstructorRegisterModel.fromJson(decodedJson);
    } else {
      throw Exception("instructor registration ${response.body}");
    }
  } catch(e) {
    throw Exception("Loading Problem: $e");
  }
}
}