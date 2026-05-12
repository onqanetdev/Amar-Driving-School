import 'package:flutter/material.dart';

import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  /// 🔹 Controllers (CORRECT WAY)
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🔥 Set initial data (replace with API later)
    nameController.text = "Amarjit Sharma";
    emailController.text = "amar@email.com";
    phoneController.text = "+91 9876543210";
    addressController.text = "Kolkata, India";
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(
        children: [

          /// ================= HEADER =================
          Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 100, bottom: 80),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff0E2853),
                      Color(0xff3368D7),
                    ],
                  ),
                ),
              ),

              /// 👤 PROFILE IMAGE
              Positioned(
                left: 0,
                right: 0,
                bottom: -55,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          "assets/app_icons/user_black.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// ================= BODY =================
          Expanded(
            child: Column(
              children: [

                const SizedBox(height: 70),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [

                        /// 🔷 CARD
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Column(
                            children: [

                              /// NAME
                              AppInputField(
                                controller: nameController,
                                hintText: "Full Name",
                                fillColor: AppColor.colorInputBg,
                                borderColor: AppColor.colorInputBorder,
                                focusedBorderColor: AppColor.colorInputFocusBorder,
                                hintColor: AppColor.colorInputHint,
                                iconPath: 'assets/app_icons/user_black.png',
                                borderRadius: 10,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                readOnly: false,
                              ),

                              const SizedBox(height: 12),

                              /// EMAIL
                              AppInputField(
                                controller: emailController,
                                hintText: "Email",
                                fillColor: AppColor.colorInputBg,
                                borderColor: AppColor.colorInputBorder,
                                focusedBorderColor: AppColor.colorInputFocusBorder,
                                hintColor: AppColor.colorInputHint,
                                iconPath: 'assets/app_icons/email.png',
                                borderRadius: 10,
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                readOnly: false,
                              ),

                              const SizedBox(height: 12),

                              /// PHONE
                              AppInputField(
                                controller: phoneController,
                                hintText: "Phone",
                                fillColor: AppColor.colorInputBg,
                                borderColor: AppColor.colorInputBorder,
                                focusedBorderColor: AppColor.colorInputFocusBorder,
                                hintColor: AppColor.colorInputHint,
                                iconPath: 'assets/app_icons/telephone.png',
                                borderRadius: 10,
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                                readOnly: true,
                              ),

                              const SizedBox(height: 12),

                              /// ADDRESS
                              AppInputField(
                                controller: addressController,
                                hintText: "Address",
                                fillColor: AppColor.colorInputBg,
                                borderColor: AppColor.colorInputBorder,
                                focusedBorderColor: AppColor.colorInputFocusBorder,
                                hintColor: AppColor.colorInputHint,
                                iconPath: 'assets/app_icons/ic_address.png',
                                borderRadius: 10,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                readOnly: false,
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔷 EDIT BUTTON
                        AppButton(
                          text: "Edit Profile",
                          onTap: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );*/
                          },
                          textStyle: const TextStyle(
                            fontFamily: "InterBold",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}