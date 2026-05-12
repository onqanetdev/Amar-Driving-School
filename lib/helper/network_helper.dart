import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {

  static Future<bool> isInternetAvailable() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    /// ❌ No network at all
    if (connectivityResult == ConnectivityResult.none) return false;

    /// 🔥 Primary check (Google)
    try {
      final response = await http
          .head(Uri.parse("https://www.google.com/generate_204"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 204) return true;
    } catch (_) {}

    /// 🔁 Fallback check (Cloudflare)
    try {
      final response = await http
          .head(Uri.parse("https://www.cloudflare.com/cdn-cgi/trace"))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) return true;
    } catch (_) {}

    return false;
  }
}