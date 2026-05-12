import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:http/http.dart' as http;
import '../screen/common_screen/update_app_screen/UpdateAppScreen.dart';
import 'ApiService.dart';
import 'helper.dart';

class AppUpdateChecker {

  static bool _checking = false;

  static Future<void> check(BuildContext context) async {

    if (_checking) return;
    _checking = true;

    try {

      final response = await http
          .get(Uri.parse(ApiService.APP_VERSION_CHECK))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        _checking = false;
        return;
      }

      final data = jsonDecode(response.body);

      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      //currentVersion="1.0.0";

      String latestVersion;
      String link;
      String message;

      if (Platform.isAndroid) {
        latestVersion = data['data']['versionname'];
        link = data['data']['androidlink'];
      } else {
        latestVersion = data['data']['iosversionname'];
        link = data['data']['ioslink'];
      }

      message = data['data']['message'];

      currentVersion="1.0.0";
      latestVersion="1.0.0";

      final needUpdate =
      Helper.IsUpdateAvailable(context, currentVersion, latestVersion);

      if (!needUpdate) {
        _checking = false;
        return;
      }

      if (!context.mounted) {
        _checking = false;
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => UpdateAppScreen(
            message: message,
            storeLink: link,
          ),
        ),
            (route) => false,
      );

    } catch (e) {
      debugPrint("Update check error: $e");
    }

    _checking = false;
  }
}