import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  /// Returns true if internet is available
  static Future<bool> hasInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// A wrapper to execute API only when internet is available
  static Future<T?> safeApiCall<T>(
      Future<T> Function() apiCall, {
        required Function onNoInternet,
      }) async {
    if (await hasInternetConnection()) {
      return await apiCall();
    } else {
      onNoInternet();
      return null;
    }
  }
}