import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_update_state.dart';

class AppMigrationManager {

  static const String _installedVersionKey = "installed_app_version";

  static Future<void> runMigration() async {

    final prefs = await SharedPreferences.getInstance();
    final info = await PackageInfo.fromPlatform();

    final String currentVersion = info.version;
    final String? oldVersion = prefs.getString(_installedVersionKey);

    /// FIRST INSTALL
    if (oldVersion == null) {
      await prefs.setString(_installedVersionKey, currentVersion);
      return;
    }

    /// APP UPDATED
    if (oldVersion != currentVersion) {

      print("APP UPDATED: $oldVersion -> $currentVersion");

      /// 🧹 CLEAR ONLY APP CONFIG (NOT USER LOGIN)
      final name = prefs.getString("Name");
      final userId = prefs.getString("UserId");
      final phone = prefs.getString("PhoneNumber");

      await prefs.clear();

      /// restore login session
      if (name != null) await prefs.setString("Name", name);
      if (userId != null) await prefs.setString("UserId", userId);
      if (phone != null) await prefs.setString("PhoneNumber", phone);

      /// allow future update popup
      AppUpdateState.isDialogShowing = false;

      await prefs.setString(_installedVersionKey, currentVersion);
    }
  }
}