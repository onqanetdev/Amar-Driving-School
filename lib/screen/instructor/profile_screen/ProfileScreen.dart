
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/common/profile_bloc.dart';
import '../../../bloc/common/profile_event.dart';
import '../../../bloc/common/profile_state.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_event.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/loader_helper.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_textfield.dart';
import '../../common_screen/about_us_and_TermsNconditions/CmsPageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_screen/contact_us_form/contact_us_form.dart';


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

    fetchProfile();
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
    return BlocListener<ProfileBloc, ProfileState>(

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

            addressController.text =
            " ";
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

                          /// 🔷 CARD - USER DETAILS
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
                                // AppInputField(
                                //   controller: addressController,
                                //   hintText: "Address",
                                //   fillColor: AppColor.colorInputBg,
                                //   borderColor: AppColor.colorInputBorder,
                                //   focusedBorderColor: AppColor.colorInputFocusBorder,
                                //   hintColor: AppColor.colorInputHint,
                                //   iconPath: 'assets/app_icons/ic_address.png',
                                //   borderRadius: 10,
                                //   obscureText: false,
                                //   keyboardType: TextInputType.text,
                                //   readOnly: false,
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🔷 NEW CARD - LEGAL & OPTIONS
                          Container(
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

                                /// TERMS & CONDITIONS
                                _buildMenuOption(
                                  icon: Icons.description_outlined,
                                  title: "Terms & Conditions",
                                  onTap: () {
                                    // TODO: Handle Terms & Conditions tap
                                    _handleTermsAndConditions();
                                  },
                                ),

                                const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFEEEEEE)),

                                /// ABOUT US
                                _buildMenuOption(
                                  icon: Icons.info_outline,
                                  title: "About Us",
                                  onTap: () {
                                    // TODO: Handle About Us tap
                                    _handleTapped();
                                  },
                                ),

                                const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFEEEEEE)),

                                /// PRIVACY POLICY
                                _buildMenuOption(
                                  icon: Icons.content_paste_outlined, // Fallback if shield icon differs
                                  alternativeIcon: Icons.lock_outline,
                                  title: "Privacy Policy",
                                  onTap: () {
                                    // TODO: Handle Privacy Policy tap
                                    _handlePrivacyPolicy();
                                  },
                                ),

                                const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFEEEEEE)),

                                /// Contact Us
                                _buildMenuOption(
                                  icon: Icons.local_phone, // Fallback if shield icon differs
                                  alternativeIcon: Icons.local_phone,
                                  title: "Contact Us",
                                  onTap: () {
                                    // TODO: Handle Contact Us tap
                                    _handleContactUs();
                                  },
                                ),

                              ],
                            ),
                          ),

                          // const SizedBox(height: 24),
                          //
                          // /// 🔷 EDIT BUTTON
                          // AppButton(
                          //   text: "Edit Profile",
                          //   onTap: () {
                          //     /*Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (_) => const EditProfileScreen(),
                          //       ),
                          //     );*/
                          //   },
                          //   textStyle: const TextStyle(
                          //     fontFamily: "InterBold",
                          //     fontSize: 12,
                          //     color: Colors.white,
                          //   ),
                          // ),

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
      ),
    );

  }

  Future<void> fetchProfile() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    context.read<ProfileBloc>().add(

      FetchProfile(

        userId:
        userId.toString(),
      ),
    );
  }

   void _handleTapped() {
     Navigator.push(

       context,

       MaterialPageRoute(

         builder: (_) => BlocProvider(

           create: (_) => InstructorAboutUsBloc()

             ..add(

               FetchInstructorAboutUs(

                 pageTitle: "About Us",
               ),
             ),

           child: const CmsPageScreen(

             title: "About Us",
           ),
         ),
       ),
     );
  }
  void _handleTermsAndConditions() {
    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => BlocProvider(

          create: (_) => InstructorAboutUsBloc()

            ..add(

              FetchInstructorAboutUs(

                pageTitle:
                "Term & Conditions",
              ),
            ),

          child: const CmsPageScreen(

            title:
            "Terms & Conditions",
          ),
        ),
      ),
    );
  }
  //Handle Privacy Policy

  void _handlePrivacyPolicy() {
    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => BlocProvider(

          create: (_) => InstructorAboutUsBloc()

            ..add(

              FetchInstructorAboutUs(

                pageTitle:
                "Privacy Policy",
              ),
            ),

          child: const CmsPageScreen(

            title:
            "Privacy Policy",
          ),
        ),
      ),
    );
  }

  void _handleContactUs() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => ContactUsScreen(title: 'Contact Us',),
      ),
    );

  }

  /// Helper widget to build individual clean menu options rows
  Widget _buildMenuOption({
    required IconData icon,
    IconData? alternativeIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              alternativeIcon ?? icon,
              color: Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: "InterMedium", // Replace with your font family if different
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}