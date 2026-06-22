
import 'package:http/http.dart' as http;

import '../../helper/network_helper.dart';

class ApiHelper {

  static Future<http.Response> get(String url,) async {

    if (!await NetworkHelper.isInternetAvailable()) {
      throw Exception("No Internet Connection");
    }

    return await http.get(
      Uri.parse(url),
    );
  }

  static Future<http.Response> post({
    required String url,
    Map<String, String>? body,
    Map<String, String>? headers,
  }) async {

    if (!await NetworkHelper.isInternetAvailable()) {
      throw Exception("No Internet Connection");
    }

    return await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
  } // async Ending
}

