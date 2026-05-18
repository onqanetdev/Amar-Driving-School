import 'package:amar_driving_school/bloc/instructor/instructor_register_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_event.dart';
import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/screen/Student/dashboard_screen/StudentDashboardScreen.dart';
import 'package:amar_driving_school/screen/instructor/dashboard_screen/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../bloc/instructor/instructor_register_event.dart';
import '../../../bloc/instructor/instructor_register_state.dart';
import '../../../bloc/instructor/lesson_list/instructor_lesson_list_bloc.dart';
import '../../../bloc/instructor/login_instructor/instructor_login_state.dart';
import '../../../bloc/instructor/student_total_count/instructor_student_count_bloc.dart';
import '../../../bloc/student/student_login/student_login_bloc.dart';
import '../../../bloc/student/student_login/student_login_event.dart';
import '../../../bloc/student/student_login/student_login_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helper/loader_helper.dart';
import '../../../helper/network_helper.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  /// Toggle
  bool isRegister = false;
  bool isLoading = false;
  /// Role
  String selectedRole = "instructor";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return MultiBlocListener(
      listeners: [

        BlocListener<InstructorRegBloc, InstructorRegisterState>(
          listener: (context, state) async {

            if(state is InstructorRegisterLoading) {
              LoaderHelper.show(context);
            }

            if(state is InstructorRegisterSuccess)  {
              LoaderHelper.hide(context);

              final prefs = await SharedPreferences.getInstance();

              /// 🔥 SAVE SESSION
              await prefs.setBool('loggedIn', true);

              await prefs.setString(
                'selected_role',
                'instructor',
              );

              /// 🔥 SAVE USER DATA
              await prefs.setString(
                'user_id',
                state.instructRegResponseData.data.login_id as String,
              );

              _showMsg(state.instructRegResponseData.message);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                 // builder: (_) => const DashboardScreen(),
                  builder: (_) => MultiBlocProvider(

                    providers: [

                      BlocProvider(
                        create: (_) =>
                            InstructorStudentCountBloc(),
                      ),

                      BlocProvider(
                        create: (_) =>
                            InstructorLessonListBloc(),
                      ),

                    ],

                    child: const DashboardScreen(),
                  ),
                ),
                    (route) => false,
              );
            }

            if(state is InstructorRegisterFailure) {
              LoaderHelper.hide(context);
            }
          },
        ),

        BlocListener<InstructorLoginBloc, InstructorLoginState>(
          listener: (context, state) async {

            if(state is InstructorLoginLoading) {
              LoaderHelper.show(context);
            }

            if(state is InstructorLoginSuccess) {
              LoaderHelper.hide(context);
              final prefs = await SharedPreferences.getInstance();

              await prefs.setBool('loggedIn', true);
              await prefs.setString('selected_role', selectedRole);
              /// 🔥 SAVE USER ID
              await prefs.setString(
                'user_id',
                state.responseInstructorLogin.instructor.userId! ,
              );

              _showMsg(state.responseInstructorLogin.message);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  //builder: (_) => const DashboardScreen(),
                  builder: (_) => MultiBlocProvider(

                    providers: [

                      BlocProvider(
                        create: (_) =>
                            InstructorStudentCountBloc(),
                      ),

                      BlocProvider(
                        create: (_) =>
                            InstructorLessonListBloc(),
                      ),

                    ],

                    child: const DashboardScreen(),
                  ),
                ),
                    (route) => false,
              );
            }

            if(state is InstructorLoginFailure) {
              LoaderHelper.hide(context);
            }
          },
        ),

        BlocListener<StudentLoginBloc, StudentLoginState>(
          listener: (context, state) async {

            if(state is StudentLoginLoading) {
              LoaderHelper.show(context);
            }

            if(state is StudentLoginSuccess) {

              LoaderHelper.hide(context);

              final prefs = await SharedPreferences.getInstance();

              await prefs.setBool('loggedIn', true);
              await prefs.setString('selected_role', 'student');
              await prefs.setString(
                'user_id',
                state.studResdata.student.loginId as String,
              );

              _showMsg(state.studResdata.message);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentDashboardScreen(),

                ),
                    (route) => false,
              );
            }

            if(state is StudentLoginFailure) {

              LoaderHelper.hide(context);

              _showMsg(state.error);
            }
          },
        ),

      ],

      child: Scaffold(
              body: Stack(
                children: [
                  /// 🌄 Background
                  Positioned.fill(
                    child: Image.asset(
                      "assets/app_images/background_image.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// 🔥 CENTERED UI
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Image.asset('assets/app_images/logo_of_amar.png',
                                    width: 140,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(height: 20,),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: isRegister ? 'Sign up' : 'Login',
                                              style: TextStyle(
                                                fontFamily: "InterBold",
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: HexColor(AppColor.colorOfSignUp),
                                              )
                                          ),
                                          TextSpan(
                                            text: ' to your \nAccount',
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: "InterBold",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),

                                  SizedBox(height: 20,),

                                  _buildFormCard(),

                                  /// 🔥 MAIN CONTAINER (TOP)
                                  /*AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: _buildFormCard(),
                              ),*/

                                  isRegister?SizedBox(height: 25):SizedBox(height: 90,),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );

  }

  /// MAIN CARD UI
  Widget _buildFormCard() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// 🔘 ROLE SELECTOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roleItem("instructor", "Instructor"),
              const SizedBox(width: 25),
              _roleItem("student", "Student"),
            ],
          ),

          const SizedBox(height: 15),

          /// 🔥 REGISTER MODE
          if (isRegister) ...[
            AppInputField(
              controller: _nameController,
              hintText: "Full Name",
              fillColor: AppColor.colorInputBg,
              borderColor: AppColor.colorInputBorder,
              focusedBorderColor: AppColor.colorInputFocusBorder,
              hintColor: AppColor.colorInputHint,
              iconPath: 'assets/app_icons/user_white.png',
              borderRadius: 10,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            AppInputField(
              controller: _emailController,
              hintText: "Email",
              fillColor: AppColor.colorInputBg,
              borderColor: AppColor.colorInputBorder,
              focusedBorderColor: AppColor.colorInputFocusBorder,
              hintColor: AppColor.colorInputHint,
              iconPath: 'assets/app_icons/email.png',
              borderRadius: 10,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
            ),
            const SizedBox(height: 10),

            AppInputField(
              controller: _phoneController,
              hintText: "Phone",
              fillColor: AppColor.colorInputBg,
              borderColor: AppColor.colorInputBorder,
              focusedBorderColor: AppColor.colorInputFocusBorder,
              hintColor: AppColor.colorInputHint,
              iconPath: 'assets/app_icons/telephone.png',
              borderRadius: 10,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              obscureText: false,
            ),
            const SizedBox(height: 10),

            AppInputField(
              controller: _passwordController,
              hintText: "Password",
              fillColor: AppColor.colorInputBg,
              borderColor: AppColor.colorInputBorder,
              focusedBorderColor: AppColor.colorInputFocusBorder,
              hintColor: AppColor.colorInputHint,
              iconPath: 'assets/app_icons/password_manager.png',
              borderRadius: 10,
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
          ]

          /// 🔥 LOGIN MODE
          else ...[
            if (selectedRole == "student") ...[
              AppInputField(
                controller: _codeController,
                hintText: "Code",
                fillColor: AppColor.colorInputBg,
                borderColor: AppColor.colorInputBorder,
                focusedBorderColor: AppColor.colorInputFocusBorder,
                hintColor: AppColor.colorInputHint,
                iconPath: 'assets/app_icons/ic_code.png',
                borderRadius: 10,
                maxLength: 6,
                keyboardType: TextInputType.number,
                obscureText: false,
              ),
            ] else ...[
              AppInputField(
                controller: _emailController,
                hintText: "Email",
                fillColor: AppColor.colorInputBg,
                borderColor: AppColor.colorInputBorder,
                focusedBorderColor: AppColor.colorInputFocusBorder,
                hintColor: AppColor.colorInputHint,
                iconPath: 'assets/app_icons/email.png',
                borderRadius: 10,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
              ),
              const SizedBox(height: 10),

              AppInputField(
                controller: _passwordController,
                hintText: "Password",
                fillColor: AppColor.colorInputBg,
                borderColor: AppColor.colorInputBorder,
                focusedBorderColor: AppColor.colorInputFocusBorder,
                hintColor: AppColor.colorInputHint,
                iconPath: 'assets/app_icons/password_manager.png',
                borderRadius: 10,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
            ],
          ],

          const SizedBox(height: 12),

          /// 🔘 BUTTON
          AppButton(
            text: isRegister ? "SIGN UP" : "LOGIN",
            onTap: _handleAction,
            assetIcon: "assets/app_icons/login_logo.png",
            textStyle: TextStyle(
              fontFamily: "InterBold",
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          /// 🔁 SWITCH
    if (selectedRole == "instructor") ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isRegister
                    ? "Already have account? "
                    : "Don't have account? ",
                style: const TextStyle(
                  fontFamily: 'InterMedium',
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 5),
              AppButtonAnimation(
                onTap: (){
                  setState(() {
                    isRegister = !isRegister;
                  });
                },
                child: Text(
                  isRegister ? "Login" : "Register",
                  style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              )
            ],
          ),
          ],

          /// 🔥 FORGOT PASSWORD ONLY FOR INSTRUCTOR LOGIN
          if (!isRegister && selectedRole == "instructor") ...[
            const SizedBox(height: 6),
            AppButtonAnimation(
              onTap: (){
                _showForgotPasswordDialog();
              },
              child: const Text(
                "Forget Password",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 13,
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    final otpController = TextEditingController();

    bool isOtpSent = false;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// 🔥 TITLE
                    Row(
                      children: [
                        Icon(
                          isOtpSent ? Icons.verified : Icons.lock_reset,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isOtpSent ? "Enter OTP" : "Reset Password",
                          style: const TextStyle(
                            fontFamily: "InterBold",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 EMAIL FIELD
                    if (!isOtpSent)
                      AppInputField(
                        controller: emailController,
                        hintText: "Email",
                        fillColor: AppColor.colorInputBg,
                        borderColor: AppColor.colorInputBorder,
                        focusedBorderColor:
                        AppColor.colorInputFocusBorder,
                        hintColor: AppColor.colorInputHint,
                        iconPath: 'assets/app_icons/email.png',
                        borderRadius: 10,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),

                    /// 🔹 OTP FIELD
                    if (isOtpSent)
                      AppInputField(
                        controller: otpController,
                        hintText: "Enter OTP",
                        fillColor: AppColor.colorInputBg,
                        borderColor: AppColor.colorInputBorder,
                        focusedBorderColor:
                        AppColor.colorInputFocusBorder,
                        hintColor: AppColor.colorInputHint,
                        iconPath: 'assets/app_icons/ic_code.png',
                        borderRadius: 10,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        obscureText: false,
                      ),

                    const SizedBox(height: 20),

                    /// 🔘 BUTTONS
                    Row(
                      children: [
                        /// 🔹 CANCEL BUTTON (Secondary)
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontFamily: "InterMedium",
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 🔥 PRIMARY BUTTON
                        Expanded(
                          child: AppButton(
                            height: 42, // 👈 IMPORTANT
                            text: isOtpSent ? "Submit" : "Send OTP",
                            onTap: isLoading
                                ? null
                                : () async {
                              if (!isOtpSent) {
                                final email = emailController.text.trim();

                                if (email.isEmpty) {
                                  _showMsg("Enter email");
                                  return;
                                }

                                if (!Helper.isValidEmail(email)) {
                                  _showMsg("Enter valid email");
                                  return;
                                }

                                setStateDialog(() => isLoading = true);

                                await Future.delayed(const Duration(seconds: 1));

                                setStateDialog(() {
                                  isLoading = false;
                                  isOtpSent = true;
                                });

                                _showMsg("OTP sent to email");

                              } else {
                                final otp = otpController.text.trim();

                                if (otp.isEmpty) {
                                  _showMsg("Enter OTP");
                                  return;
                                }

                                if (otp.length != 6) {
                                  _showMsg("Enter valid OTP");
                                  return;
                                }

                                Navigator.pop(context);

                                _showMsg("OTP verified");
                              }
                            },
                            textStyle: const TextStyle(
                              fontFamily: "InterBold",
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 🔘 ROLE ITEM
  Widget _roleItem(String role, String title) {
    final isSelected = selectedRole == role;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selectedRole = role;

          _emailController.clear();
          _passwordController.clear();
        });
      },
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ACTION
  void _handleAction() {
    if (isLoading) return;
    if (isRegister) {
      _handleRegister();
    } else {
      _handleLogin();
    }
  }

  Future<void> _handleLogin() async {
    /// 🌐 Internet check
    if (!await NetworkHelper.isInternetAvailable()) {
      _showMsg("No Internet Connection");
      return;
    }

    if (selectedRole == "student") {
      final code = _codeController.text.trim();

      if (code.isEmpty) {
        _showMsg("Enter code");
        return;
      }

      if (code.length != 6) {
        _showMsg("Enter valid 6 digit code");
        return;
      }

      context.read<StudentLoginBloc>().add(
        StudentLoggedInTapped(loggedInId: code),
      );

    }
    else
    {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty) {
        _showMsg("Enter email");
        return;
      }

      if (!Helper.isValidEmail(email)) {
        _showMsg("Enter valid email");
        return;
      }

      if (password.isEmpty) {
        _showMsg("Enter password");
        return;
      }


      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('loggedIn', true);
      // await prefs.setInt('userId', 1127);
      // await prefs.setString('user_name', 'Example');
      // await prefs.setString('selected_role', selectedRole);
      

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
      //       (route) => false,
      // );

      // setState(() => isLoading = true);
      context.read<InstructorLoginBloc>().add(
        InstructorLoginTapped(email: email, password: password)
      );

    }
  }

  Future<void> _handleRegister() async {
    /// 🌐 Internet check
    if (!await NetworkHelper.isInternetAvailable()) {
      _showMsg("No Internet Connection");
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showMsg("Enter full name");
      return;
    }

    if (name.length < 3) {
      _showMsg("Name must be at least 3 characters");
      return;
    }

    if (email.isEmpty) {
      _showMsg("Enter email");
      return;
    }

    if (!Helper.isValidEmail(email)) {
      _showMsg("Enter valid email");
      return;
    }

    if (phone.isEmpty) {
      _showMsg("Enter phone number");
      return;
    }

    if (phone.length != 10) {
      _showMsg("Enter valid 10 digit phone");
      return;
    }

    if (password.isEmpty) {
      _showMsg("Enter password");
      return;
    }

    if (password.length < 6) {
      _showMsg("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    print('Flutter Pub');
    print('Name ${_nameController.text}, Email is ${_emailController.text}, password is ${_passwordController.text}, phone number ${_phoneController.text}');

    /// 🔥 CALL BLOC EVENT HERE
    context.read<InstructorRegBloc>().add(
      InstructorRegTapped(
        name: name,
        email: email,
        phone: phone,
        password: password,
      ),
    );
  }

  void _showMsg(String msg) {
    Helper.showToast(context, msg);
  }
}