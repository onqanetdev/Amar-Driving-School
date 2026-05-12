import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/ApiService.dart';
import '../../../helper/helper.dart';
import '../splash_screen/SplashScreen.dart';

class UpdateAppScreen extends StatelessWidget {
  final String message;
  final String storeLink;

  const UpdateAppScreen({
    Key? key,
    required this.message,
    required this.storeLink,
  }) : super(key: key);

  void _openStore() {
    Helper.LaunchAppStore(storeLink);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔥 prevent back button
      child: Scaffold(
        body: Stack(
          children: [

            /// Background
            Positioned.fill(
              child: Image.asset(
                "assets/app_images/splash_screen_bg.png",
                fit: BoxFit.cover,
              ),
            ),

            /// Dark overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.65),
              ),
            ),

            /// Update Card
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/app_images/logo.png',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Update Required",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _openStore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("${AppColor.colorAppButton}"), // button bg
                            foregroundColor: Colors.white, // text color
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Update Now",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}