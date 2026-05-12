import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/CustomLoader.dart';
import '../../../common/api.dart';
import '../../../common/app_color.dart' show AppColor;
import '../../../common/convert_color.dart' show HexColor;
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/ApiService.dart';
import '../../../helper/app_update_checker.dart';
import '../../../helper/helper.dart';

class NewLoginScreen extends StatefulWidget {
  static String routeName = "/new_login_screen";
  const NewLoginScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> with WidgetsBindingObserver{

  bool isLogin = true;
  //bool isLogin = false;
  bool showOtp = false;
  String? _otpResponse="";
  String? _userIdResponse="";

  String? _currentVersion="";
  String? _android_link="";
  String? _ios_link="";
  String _latest_verstion_apk="";
  String _latest_verstion_ios="";
  String apk_close="";
  String ios_close="";
  String _app_upadte_message="";
  String _skipLogin="No";

  TextEditingController _name=TextEditingController();
  TextEditingController _mobile=TextEditingController();
  TextEditingController _otp=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();

  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  FocusNode _focusNodeName = FocusNode();
  bool _isFocusedName = true;

  FocusNode _focusNodeMobile = FocusNode();
  bool _isFocusedMobile = true;

  FocusNode _focusNodeOTP = FocusNode();
  bool _isFocusedOTP = true;

  FocusNode _focusNodeEmail = FocusNode();
  bool _isFocusedEmail = false;
  //bool passwordVisible=false;
  late bool passwordVisible;
  TextEditingController _forgotPassword = TextEditingController();

  bool _isSubmitting = false;
  bool _regApiSuccess = false;

  bool isTestMode=false;
  double _scale = 1.0;

  void _getUserLoginData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _skipLogin = prefs.getString('SkipLogin')??"";
    });

  }

  //...Push Notification...........

  Future<void> _askNotificationPermission() async {
    /*bool granted = await FirebaseNotificationService().requestNotificationPermission();
    if (granted) {
      print("✅ Notification permission granted");
      await FirebaseNotificationService().initFCM();
    } else {
      print("❌ Notification permission denied");
    }*/
  }

  //.........end........

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppUpdateChecker.check(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    /// ⭐ FIRST TIME OPEN CHECK (THIS WAS MISSING)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppUpdateChecker.check(context);
    });
    _getUserLoginData(context);

    //fetchData();

    _focusNodeName.addListener(_onFocusChange);
    _focusNodeEmail.addListener(_onFocusChange);
    _focusNodeMobile.addListener(_onFocusChange);
    _focusNodeOTP.addListener(_onFocusChange);


    passwordVisible=false;

    _forgotPassword.text = "";


    _email.text = "";
    _password.text = "";


    //...Push Notification...........
    /// Only ONE permission request → SAFE!
    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      await _askNotificationPermission();
    });*/

    //.........end........

  }

  void _onFocusChange() {
    setState(() {
      _isFocusedName = _focusNodeName.hasFocus;
      _isFocusedEmail = _focusNodeEmail.hasFocus;
      _isFocusedMobile = _focusNodeMobile.hasFocus;
      _isFocusedOTP = _focusNodeOTP.hasFocus;

    });
  }

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
      showOtp = false;
      _isSubmitting = false;
      _isFocusedMobile = _focusNodeMobile.hasFocus;
      _isFocusedOTP = _focusNodeOTP.hasFocus;
      //FocusScope.of(context).requestFocus(_focusNodeMobile);
      _mobile.clear();
      _otp.clear();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNodeEmail.dispose();
    _focusNodeName.dispose();
    _focusNodeMobile.dispose();
    _focusNodeOTP.dispose();
    super.dispose();
  }

  Future<bool> isInternetAvailable() async {

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;

    try {
      final response = await http
          .get(Uri.parse("https://www.google.com/generate_204"))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 204;
    } catch (_) {
      try {
        final fallback = await http
            .get(Uri.parse("https://www.cloudflare.com/cdn-cgi/trace"))
            .timeout(const Duration(seconds: 5));
        return fallback.statusCode == 200;
      } catch (_) {
        return false;
      }
    }
  }

  void _showNoInternetDialog(String api_call) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        title: const Text("No Internet"),
        content: const Text("Please check your connection and try again."),
        actions: [
          TextButton(
            onPressed: () async {
              // Close the dialog on the same navigator that opened it
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              // Retry the intended API call
              if ("Login" == api_call) {
                // 🔹 Close keyboard (works on all devices: Oppo, Vivo, Nothing, Samsung, etc.)
                await closeKeyboard(context);

                _handleLogin();

              } else if ("Registration" == api_call) {
                // 🔹 Close keyboard (works on all devices: Oppo, Vivo, Nothing, Samsung, etc.)
                await closeKeyboard(context);
                print('It is Registration');
                //_handleRegistration();
              } else if ("CheckOTP" == api_call) {
                // 🔹 Close keyboard (works on all devices: Oppo, Vivo, Nothing, Samsung, etc.)
                await closeKeyboard(context);

                _handleCheckOTP();
              }
            },
            child: const Text("Retry"),
          )
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final phone = _mobile.text.trim();

    // Empty/format checks
    if (phone.isEmpty) {
      Helper.showToast(context, 'Please enter phone number');
      return;
    }
    if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      Helper.showToast(context, 'Please enter a valid 10-digit phone number');
      return;
    }

    final online = await isInternetAvailable();
    if (!online) {
      _showNoInternetDialog("Login");
      return;
    }

    // show loader on root navigator
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CustomLoader(),
      ),
    );

    try {
      final result = await ApiService().loginWithPhone(phone);

      if (result['success']) {
        final message = result['message'];
        final userId = result['user_id'];
        final otp = result['otp'];

        setState(() {
          _otpResponse = otp.toString();
          _userIdResponse = userId.toString();
          showOtp = true;
          _isSubmitting = true;
        });

        Helper.showToast(context, '$message');
      } else {
        Helper.showToast(context, result['message']);
        setState(() {
          isLogin = true;
          showOtp = false;
          _isFocusedMobile = _focusNodeMobile.hasFocus;
          _isFocusedOTP = _focusNodeOTP.hasFocus;
          _otp.clear();
        });
      }
    } catch (e, st) {
      // optional logging
      debugPrint('login error: $e\n$st');
      Helper.showToast(context, 'Something went wrong. Please try again.');
    } finally {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
  // Future<void> _handleRegistration() async {
  //   final phone = _mobile.text.trim();
  //   final name = _name.text.trim();
  //
  //   if (name.isEmpty) {
  //     Helper.showToast(context, 'Please enter your name');
  //     FocusScope.of(context).requestFocus(_focusNodeName);
  //     return;
  //   }
  //
  //   if (phone.isEmpty) {
  //     Helper.showToast(context, 'Please enter phone number');
  //     return;
  //   }
  //   if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
  //     Helper.showToast(context, 'Please enter a valid 10-digit phone number');
  //     return;
  //   }
  //
  //   final online = await isInternetAvailable();
  //   if (!online) {
  //     _showNoInternetDialog("Registration");
  //     return;
  //   }
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     useRootNavigator: true,
  //     builder: (context) => const Dialog(
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       child: CustomLoader(),
  //     ),
  //   );
  //
  //   try {
  //
  //     print('WTF is Going on here ?');
  //     final result = await ApiService().registrationWithPhone(phone,name);
  //     if (result['success']) {
  //       final message = result['message'];
  //       final userId = result['user_id'];
  //       final otp = result['otp'];
  //
  //       setState(() {
  //         _otpResponse = otp.toString();
  //         _userIdResponse = userId.toString();
  //         showOtp = true;
  //         _isSubmitting = true;
  //         _regApiSuccess = true;
  //       });
  //
  //       Helper.showToast(context, '$message');
  //     } else {
  //       Helper.showToast(context, result['message']);
  //     }
  //   } catch (e, st) {
  //     debugPrint('registration error: $e\n$st');
  //     Helper.showToast(context, 'Something went wrong. Please try again.');
  //   } finally {
  //     if (Navigator.of(context, rootNavigator: true).canPop()) {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     }
  //   }
  //
  // }
  Future<void> _handleCheckOTP() async {
    final _otpSend = _otp.text.trim();

    if (_otpSend.isEmpty) {
      Helper.showToast(context, 'Please enter OTP');
      return;
    }

    if (_otpSend.length != 6 || !RegExp(r'^\d{6}$').hasMatch(_otpSend)) {
      Helper.showToast(context, 'Please enter a valid 6-digit OTP');
      return;
    }

    final online = await isInternetAvailable();
    if (!online) {
      _showNoInternetDialog("CheckOTP");
      return;
    }

    /// 🔹 Show Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: CustomLoader(),
      ),
    );

    try {

      /// 🔹 Get FCM Token (Works Android + iOS + Emulator)
      String? fcmToken;

      /*try {
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        if (Platform.isIOS) {
          await messaging.requestPermission();
        }

        fcmToken = await messaging.getToken();
      } catch (e) {
        debugPrint("FCM token error: $e");
      }*/

      debugPrint("CheckOTP token: $fcmToken");

      /// 🔹 API Call
      final response = await ApiService().checkOTP(
        _userIdResponse!,
        _otpSend,
        fcmToken ?? "",
      );

      debugPrint('CheckOTP API Response: $response');

      if (response == null) {
        Helper.showToast(context, 'Server error. Please try again.');
        return;
      }

      final message = response['message'];

      if (response['status'] == true) {

        /*if (fcmToken != null && fcmToken.isNotEmpty) {
          try {
            await FirebaseMessaging.instance.subscribeToTopic("drivers_gujaratdriver");
            debugPrint("Subscribed to topic: drivers_kolkata");
          } catch (e) {
            debugPrint("Topic subscription failed: $e");
          }
        }*/

        final user = response['user'];

        String _name = user['name'] ?? "";
        String _email = user['email'] ?? "";
        String _phone = user['phone'] ?? "";
        int _userid = user['id'] ?? 0;
        int _role_id = user['role_id'] ?? 0;

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString("Name", _name);
        await prefs.setString("EmailId", _email);
        await prefs.setString("UserId", _userid.toString());
        await prefs.setString("PhoneNumber", _phone);
        await prefs.setString("SkipLogin", "No");

        if (_role_id == 2) {
          await prefs.setString("Role", "Customer");
          await prefs.setString("RoleId", _role_id.toString());
        } else {
          await prefs.setString("Role", "Driver");
          await prefs.setString("RoleId", _role_id.toString());
        }

        Helper.showToast(context, '$message');

        /// 🔹 Navigate to Dashboard
        if (mounted) {
          /*Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => DashboardScreen()),
                (route) => false,
          );*/
        }

      } else {
        Helper.showToast(context, '$message');
      }

    } catch (e, st) {

      debugPrint('checkOTP error: $e\n$st');
      Helper.showToast(context, 'Something went wrong. Please try again.');

    } finally {

      /// 🔹 Always close loader safely
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          //Top-right fixed image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // VERY IMPORTANT → allows overflow
              children: [

                /// ----------- TOP BIG IMAGE -----------
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset('assets/app_images/top_image.png'),
                  ),
                ),

                /// ----------- CAR IMAGE SLIGHTLY BELOW -----------
                Positioned(
                  bottom: -30, // <-- move image BELOW top_image (adjust value)
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 250,
                    child: Image.asset(
                      'assets/app_images/car.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

              ],
            ),
          ),

          // 🔹 Bottom-left fixed image
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 90,
              height: 90,
              child: Image.asset(
                'assets/app_images/bottom_image.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
              ),
            ),
          ),

          // 🔹 Scrollable form content
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 320),

                      // -------------------- LOGIN / SIGN UP TITLE --------------------
                      Text(
                        isLogin ? "LOGIN" : "SIGN UP",
                        style: TextStyle(
                          fontFamily: 'MontserratBold',
                          color: HexColor("${AppColor.colorAppButton}"),
                          fontSize: 30,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!isLogin) ...[
                        buildInputField(
                          controller: _name,
                          focusNode: _focusNodeName,
                          hintText: 'Name',
                          inputType: TextInputType.text,
                          enabled: !_isSubmitting,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 10,)
                      ],

                      // 🔹 Mobile number input
                      buildInputField(
                        controller: _mobile,
                        focusNode: _focusNodeMobile,
                        hintText: 'Mobile no.',
                        inputType: TextInputType.phone,
                        maxLength: 10,
                        enabled: !_isSubmitting,
                        textInputAction: TextInputAction.done,
                      ),

                      // 🔹 OTP input
                      if (showOtp) ...[
                        const SizedBox(height: 15),
                        buildInputField(
                          controller: _otp,
                          focusNode: _focusNodeOTP,
                          hintText: 'OTP',
                          inputType: TextInputType.number,
                          maxLength: 6,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(isTestMode==true){

                                }else{
                                  _handleLogin();
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Resend your ',
                                      style: TextStyle(
                                          fontFamily: 'MontserratMedium',
                                          color: Colors.grey,
                                          fontSize: 15),
                                    ),
                                    TextSpan(
                                      text: 'OTP',
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        color: HexColor("${AppColor.colorBlack}"),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      /*recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _handleLogin();
                                        },*/
                                    ),
                                    /*TextSpan(
                                      text: '$_otpResponse',
                                      style: TextStyle(
                                        fontFamily: 'PoppinsMedium',
                                        color: HexColor("${AppColor.colorBlack}"),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 40),

                      // 🔘 Login/Sign up Button
                      InkWell(
                        onTapDown: (_) => setState(() => _scale = 0.95), // shrink slightly on tap
                        onTapUp: (_) => setState(() => _scale = 1.0),    // restore after tap
                        onTapCancel: () => setState(() => _scale = 1.0),
                        onTap: () async {
                          // 🔹 Close keyboard (works on all devices: Oppo, Vivo, Nothing, Samsung, etc.)
                          await closeKeyboard(context);

                          if(isTestMode==true){
                            if (showOtp) {

                              /*Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => DashboardScreen()),
                                    (route) => false,
                              );*/

                              print('Hello Focus');

                            }else{
                              isLogin ?_handleLogin(): print('Hello Focus');
                              setState(() {
                                showOtp = true;
                                _isSubmitting = true;
                              });
                            }

                          }else{
                            if (showOtp) {
                              _handleCheckOTP();
                            }else{
                              isLogin ?_handleLogin(): print('Handle Registration');
                            }
                          }

                          /*if (showOtp) {
                            _handleCheckOTP();
                          }else{
                            isLogin ?_handleLogin():_handleRegistration();
                          }*/

                        },
                        child: AnimatedScale(
                          scale: _scale,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: HexColor("${AppColor.colorAppButton}"),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: Text(
                              isLogin ? (showOtp ? "Submit" : "Login") : (showOtp ? "Submit" : "Sign Up"),
                              style: const TextStyle(
                                fontFamily: 'MontserratSemiBold',
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🔁 Login/Sign up switch
                      Center(
                        child: GestureDetector(
                          onTap: toggleForm,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: isLogin
                                      ? "Don’t have an account? "
                                      : "Already have an account? ",
                                  style: const TextStyle(
                                    fontFamily: 'MontserratMedium',
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: isLogin ? "Sign Up" : "Login",
                                  style: TextStyle(
                                    fontFamily: 'PoppinsBold',
                                    color: HexColor("${AppColor.colorBlack}"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString("SkipLogin", "Yes");
                          print('Tata ');
                          /*Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => DashboardScreen()),
                                (route) => false,
                          );*/
                        },
                        child: Text(
                          isLogin ? "Skip" : "",
                          style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            color: HexColor("${AppColor.colorBlack}"),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



// 🔧 Reusable input field
  Widget buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required TextInputType inputType,
    int? maxLength,
    bool enabled = true,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: inputType,
        cursorColor: Colors.black,
        enabled: enabled,
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          if (inputType == TextInputType.phone)
            FilteringTextInputFormatter.digitsOnly, // allow only numbers
        ],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'MontserratLight',
            color: HexColor("${AppColor.colorGrayDark}"),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: HexColor("${AppColor.colorBlack}")),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: HexColor("${AppColor.colorBlack}")),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(color: HexColor("${AppColor.colorBlack}")),
          ),
        ),
        style: const TextStyle(
          fontFamily: 'MontserratMedium',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> closeKeyboard(BuildContext context) async {
    FocusScope.of(context).unfocus();

    // Small delay helps prevent flicker on some OEMs
    await Future.delayed(const Duration(milliseconds: 50));

    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }


  /*fetchData() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;
    print("App current version: "+_currentVersion!);

    final response = await http.get(Uri.parse(ApiService.APP_VERSION_CHECK));

    if (response.statusCode == 200) {
      var data_value = jsonDecode(response.body.toString());
      _android_link='${data_value['data']['androidlink']}';
      _ios_link='${data_value['data']['ioslink']}';
      _latest_verstion_apk='${data_value['data']['versionname']}';
      _latest_verstion_ios='${data_value['data']['iosversionname']}';
      apk_close='${data_value['data']['appandroidstatus']}';
      ios_close='${data_value['data']['iosstatus']}';

      //_latest_verstion_apk='1.0.0';

      _app_upadte_message='${data_value['data']['message']}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("AppCurrentVersion", _currentVersion!);
      prefs.setString("AppLatestVersion", _latest_verstion_apk);
      prefs.setString("IOSLatestVersion", _latest_verstion_ios);
      prefs.setString("AndroidPlayStoreLink", _android_link!);
      prefs.setString("IosPlayStoreLink", _ios_link!);
      prefs.setString("AppVersionUpdateMsg", _app_upadte_message);
      prefs.setString("APKClose", apk_close);
      prefs.setString("IOSClose", ios_close);
      String _ptintValue="login_screen currentVersion: "+_currentVersion!+" latest_apk_verstion: "+_latest_verstion_apk+" app_upadte_message: "+_app_upadte_message+" android_link: "+_android_link!+" ios_link: "+_ios_link!+" ios_close: "+ios_close+" apk_close: "+apk_close+" latest_ios_verstion: "+_latest_verstion_ios;
      print(_ptintValue);

      //_latest_verstion_apk="2.0.0";
      //apk_close="0";
      if (Platform.isAndroid) {
        print("App install in Android Login");
        if (Helper.IsUpdateAvailable(context,_currentVersion!,_latest_verstion_apk!)) {
          Helper.AppVersionUpdateLayout(context,_app_upadte_message!,_android_link!,apk_close!);
        }

      }else{
        print("App install in IOS");
        if (Helper.IsUpdateAvailable(context,_currentVersion!,_latest_verstion_ios!)) {
          Helper.AppVersionUpdateLayout(context,_app_upadte_message!,_ios_link!,ios_close!);
        }
      }

    } else {
      throw Exception('Failed to load data');
    }
  }*/



}
