import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/app_color.dart';
import '../common/convert_color.dart';

class Helper{
  static OverlayEntry? _currentOverlay;
  static AnimationController? _controller;

  static void showToast_(BuildContext context, String message) {
    final overlay = Overlay.of(context)!;
    late OverlayEntry overlayEntry;
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );
    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height - 120,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: HexColor("${AppColor.colorAppButton}"),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    animationController.forward();

    // Fade-out after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      await animationController.reverse();
      overlayEntry.remove();
      animationController.dispose();
    });
  }
  static void showToast(BuildContext context, String message) {

    /// 🔥 REMOVE OLD TOAST FIRST
    _removeCurrent();

    final overlay = Overlay.of(context);

    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 300),
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: HexColor(AppColor.colorAppButton),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    /// 🔥 STORE CURRENT
    _currentOverlay = overlayEntry;
    _controller = controller;

    overlay.insert(overlayEntry);
    controller.forward();

    /// 🔥 AUTO REMOVE
    Future.delayed(const Duration(seconds: 2), () async {
      if (_currentOverlay == overlayEntry) {
        await controller.reverse();
        _removeCurrent();
      }
    });
  }

  /// 🔥 REMOVE METHOD
  static void _removeCurrent() {
    try {
      _controller?.stop();
      _controller?.dispose();
      _controller = null;

      _currentOverlay?.remove();
      _currentOverlay = null;
    } catch (_) {}
  }
  static bool IsUpdateAvailable(BuildContext context,String _currentVersion,String _latest_verstion) {
    List<String> currentParts = _currentVersion.split('.');
    List<String> latestParts = _latest_verstion.split('.');

    for (int i = 0; i < currentParts.length; i++) {
      int currentPart = int.parse(currentParts[i]);
      int latestPart = int.parse(latestParts[i]);

      if (latestPart > currentPart) {
        return true;
      } else if (latestPart < currentPart) {
        return false;
      }
    }

    return false;
  }

  // static Future<void> LaunchAppStore(String url) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   await prefs.setInt(
  //     "last_store_open_time",
  //     DateTime.now().millisecondsSinceEpoch,
  //   );
  //
  //   final Uri uri = Uri.parse(url);
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     debugPrint("Could not launch store URL: $url");
  //   }
  // }

  static Future<void> LaunchAppStore(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
        "last_store_open_time",
        DateTime.now().millisecondsSinceEpoch,
      );

      final Uri uri = Uri.parse(url.trim());

      debugPrint("URL = [$url]");
      debugPrint("URI = ${Uri.parse(url.trim())}");

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      // await launchUrl(
      //   Uri.parse("https://apps.apple.com/in/app/breakfix/id6751707222"),
      //   mode: LaunchMode.inAppBrowserView,
      // );

    } catch (e) {
      debugPrint("Launch error: $e");
    }
  }

  static Future<void> AppVersionUpdateLayout(
      BuildContext context,
      String message,
      String appStoreLink,
      String appUpdateClose,
      ) async {

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      useRootNavigator: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.zero,
            elevation: 0.0,
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: HexColor("${AppColor.colorDashBoardInput}"),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'App Version Check',
                          style: TextStyle(
                              fontFamily: 'OpenSauceSemiBold',
                              fontSize: 15,
                              color: HexColor("${AppColor.colorBlack}")),
                        ),

                        /// CLOSE BUTTON
                        InkWell(
                          onTap: () {
                            if (appUpdateClose == "0") {
                              Navigator.of(context, rootNavigator: true).pop();
                            } else {
                              Helper.showToast(context,
                                  'This app needs to be updated before you can use it.');
                            }
                          },
                          child: const Icon(Icons.close, color: Colors.black, size: 20),
                        ),
                      ],
                    ),
                  ),

                  /// BODY
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                              fontFamily: 'OpenSauceRegular',
                              fontSize: 15,
                              color: HexColor("${AppColor.colorBlack}")),
                        ),
                        const SizedBox(height: 20),

                        /// UPDATE BUTTON
                        InkWell(
                          onTap: () async {

                            /// 🔥 VERY IMPORTANT
                            await Helper.LaunchAppStore(appStoreLink);

                            /// dialog stays open
                            /// when user returns → resume triggers
                            /// BUT dialog already exists → no stacking
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: HexColor("${AppColor.colorAppButton}")),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: HexColor("${AppColor.colorWhite}"),
                                fontFamily: 'OpenSauceSemiBold',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void AppVersionData(String _currentVersion,String _latest_apk_verstion,String _latest_ios_verstion,String _android_link,String _ios_link,String _app_upadte_message,String _apk_close,String _ios_close) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("AppCurrentVersion", _currentVersion!);
    prefs.setString("AppLatestVersion", _latest_apk_verstion!);
    prefs.setString("IOSLatestVersion", _latest_ios_verstion!);
    prefs.setString("AndroidPlayStoreLink", _android_link!);
    prefs.setString("IosPlayStoreLink", _ios_link!);
    prefs.setString("AppVersionUpdateMsg", _app_upadte_message!);
    prefs.setString("APKClose", _apk_close!);
    prefs.setString("IOSClose", _ios_close!);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email);
  }

}
