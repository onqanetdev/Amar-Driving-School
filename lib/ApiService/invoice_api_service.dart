

import 'dart:convert';
import 'package:amar_driving_school/ApiService/helper%20class/ApiHelper.dart';
import 'package:http/http.dart' as http;
import '../model/InvoiceModel.dart';

class InvoiceApiService {

  /// API URL
  final String apiUrl =
      "https://amardrivingcrm.com/Beta/api/Student/exportuserinvoice";

  /// API CALL
  Future<InvoiceModel> exportUserInvoice({

    required String stdId,

  }) async {

    final url = Uri.parse(apiUrl);

    print("📌 EXPORT USER INVOICE API");

    try {

      final response = await ApiHelper.post(
        url: apiUrl,
        body: {
          'stdid': stdId,
        },
      );

      print("📌 STATUS CODE: ${response.statusCode}",);

      print("📌 RAW RESPONSE: ${response.body}",);

      /// 🔥 DECODE JSON
      final decodedJson = jsonDecode(response.body);

      /// 🔥 SUCCESS CHECK
      if (decodedJson['success'] == true) {
        return InvoiceModel.fromJson(decodedJson,);
      } else {
        throw Exception(decodedJson['message'],);
      }

    } catch (e) {
      print("🔥 API ERROR: $e");
      rethrow;
    }
  }
}

