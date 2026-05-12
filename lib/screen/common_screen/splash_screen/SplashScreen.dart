import 'dart:convert';
import 'dart:io';

import 'package:amar_driving_school/bloc/student/student_login/student_login_bloc.dart';
import 'package:amar_driving_school/screen/Student/dashboard_screen/StudentDashboardScreen.dart';
import 'package:amar_driving_school/screen/instructor/dashboard_screen/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/instructor/instructor_register_bloc.dart';
import '../../../bloc/instructor/login_instructor/instructor_login_bloc.dart';
import '../../../helper/ApiService.dart';
import '../../../helper/helper.dart';
import '../login_screen/LoginScreen.dart';
import '../login_screen/NewLoginScreen.dart';
import '../update_app_screen/UpdateAppScreen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAppVersion();
    });
  }

  Future<void> _checkAppVersion() async {

    try {

      final response = await http
          .get(Uri.parse(ApiService.APP_VERSION_CHECK))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        _goNext();
        return;
      }

      final data = jsonDecode(response.body);

      final packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

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

      if (needUpdate) {

        if (!mounted) return;

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

      } else {
        _goNext();
      }

    } catch (e) {
      debugPrint("Splash error: $e");
      _goNext();
    }
  }

  Future<void> _goNext() async {

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString("UserId") ?? "";
    final skipLogin = prefs.getString("SkipLogin") ?? "";

    if (userId.isNotEmpty && skipLogin != "Yes") {
      /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
      );*/
    } else {
      await precacheImage(
        const AssetImage("assets/app_images/background_image.png"),
        context,
      );

      final prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
      String selectedRole = prefs.getString('selected_role') ?? 'instructor';

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => const LoginScreen()),
      //       (route) => false,
      // );

      if (isLoggedIn) {

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
        //       (route) => false,
        // );

        if (selectedRole == 'student') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const StudentDashboardScreen()),
                (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
          );
        }


      } else {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => const LoginScreen()),
        //       (route) => false,
        // );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
            //     BlocProvider(
            //   create: (context) => InstructorRegBloc(),
            //   child: const LoginScreen(),
            // ),

            MultiBlocProvider(
              providers: [

                BlocProvider(
                  create: (context) => InstructorRegBloc(),
                ),

                BlocProvider(
                  create: (context) => InstructorLoginBloc(),
                ),

                BlocProvider(
                  create: (_) => StudentLoginBloc(),
                ),

              ],

              child: const LoginScreen(),
            )
          ),
              (route) => false,
        );

      }

    }
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/app_images/splash_screen_bg.png',
          fit: BoxFit.cover,
        ),
      ),
    );*/

    return Scaffold(
      body: Stack(
        children: [

          /// 🔹 BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/app_images/splash_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 BOTTOM LOADER
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// PROGRESS BAR (better than spinner)
                  SizedBox(
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: "InterRegular",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}