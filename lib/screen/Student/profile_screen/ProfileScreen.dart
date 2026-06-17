import 'package:flutter/material.dart';

import '../../../bloc/common/invoice/user_invoice_dart.dart';
import '../../../bloc/common/invoice/user_invoice_event.dart';
import '../../../bloc/common/invoice/user_invoice_state.dart';
import '../../../bloc/common/profile_bloc.dart';
import '../../../bloc/common/profile_event.dart';
import '../../../bloc/common/profile_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


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
  final invoiceDownloadController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// 🔥 Set initial data (replace with API later)
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    // addressController.text = "Kolkata, India";

    fetchProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    //addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [

      BlocListener<ProfileBloc, ProfileState>(

        listener: (context, state) {

          /// LOADING
          if(state is ProfileLoading) {

            LoaderHelper.show(context);
          }

          /// SUCCESS
          if(state is ProfileSuccess) {

            LoaderHelper.hide(context);

            final profile =
                state.profileResponse.data;

            nameController.text =
                profile.name;

            emailController.text =
                profile.email;

            phoneController.text =
                profile.phone;

            // addressController.text =
            // " ";
          }

          /// FAILURE
          if(state is ProfileFailure) {

            LoaderHelper.hide(context);

            ScaffoldMessenger.of(context)
                .showSnackBar(

              SnackBar(
                content:
                Text(state.error),
              ),
            );
          }
        },
      ),

      // User Invoice bloc
      BlocListener<UserInvoiceBloc, UserInvoiceState>(

        listener: (context, state) async {

          if (state is UserInvoiceLoading) {

            LoaderHelper.show(context);
          }

          if (state is UserInvoiceSuccess) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.userInvoiceResponse.message,
            );

            try {

              final invoiceUrl =
                  state.userInvoiceResponse.path;

              /// Download PDF
              final response =
              await http.get(Uri.parse(invoiceUrl));

              if (response.statusCode != 200) {

                Helper.showToast(
                  context,
                  "Failed to download invoice",
                );

                return;
              }

              /// Save to temp directory
              final directory =
              await getTemporaryDirectory();

              final file = File(
                '${directory.path}/invoice.pdf',
              );

              await file.writeAsBytes(
                response.bodyBytes,
              );

              /// Show Save / Share dialog
              await SharePlus.instance.share(

                ShareParams(

                  files: [
                    XFile(file.path),
                  ],

                  text: 'Invoice',
                ),
              );

            } catch (e) {

              print(
                "INVOICE DOWNLOAD ERROR => $e",
              );

              Helper.showToast(
                context,
                "Failed to save invoice",
              );
            }
          }

          if (state is UserInvoiceFailure) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      ),

    ],
        child: Scaffold(
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

                              /// Invoice Download
                              AppInputField(
                                controller: invoiceDownloadController,
                                hintText: "Invoice Download",
                                fillColor: AppColor.colorInputBg,
                                borderColor: AppColor.colorInputBorder,
                                focusedBorderColor: AppColor.colorInputFocusBorder,
                                hintColor: AppColor.colorInputHint,
                                iconPath: 'assets/app_icons/download.png',
                                borderRadius: 10,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                onTap: () async {

                                  final prefs = await SharedPreferences.getInstance();

                                  final userId =
                                      prefs.getString("stud_user_id") ?? "";

                                  context.read<UserInvoiceBloc>().add(
                                    UserInvoiceTapped(
                                      stdId: userId,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔷 EDIT BUTTON
                        // AppButton(
                        //   text: "Edit Profile",
                        //   onTap: () {
                        //     /*Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const EditProfileScreen(),
                        //   ),
                        // );*/
                        //   },
                        //   textStyle: const TextStyle(
                        //     fontFamily: "InterBold",
                        //     fontSize: 12,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        //
                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );

  }

  Future<void> fetchProfile() async {

    final prefs = await SharedPreferences.getInstance();

    final userId =
        prefs.getString("stud_user_id") ?? "";

    context.read<ProfileBloc>().add(

      FetchProfile(
        userId:
        userId.toString(),
      ),
    );
  }
}