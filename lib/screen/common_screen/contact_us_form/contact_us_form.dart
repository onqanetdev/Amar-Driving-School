
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_bloc.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_event.dart';
import '../../../widgets/app_header.dart';

class ContactUsScreen extends StatefulWidget {

  final String title;
  const ContactUsScreen({super.key, required this.title});

  @override
  State<ContactUsScreen> createState() =>
      _ContactUsScreenState();
}

class _ContactUsScreenState
    extends State<ContactUsScreen> {

  final firstNameController =
  TextEditingController();

  final lastNameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final contactController =
  TextEditingController();

  final messageController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFE9E9E9),

      body: Column(

        children: [

          /// HEADER
          AppHeader(

            title: widget.title,

            showBack: true,
          ),

          /// BODY
          Expanded(

            child: SingleChildScrollView(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Contact Us",

                    style: TextStyle(

                      fontSize: 34,

                      fontFamily: "InterBold",

                      color: Color(0xFF1E1E1E),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    "Get in Touch With Us",

                    style: TextStyle(

                      fontSize: 18,

                      color:
                      Colors.black.withOpacity(0.7),

                      fontFamily:
                      "InterMedium",
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// FIRST NAME
                  buildField(

                    controller:
                    firstNameController,

                    hint:
                    "First Name",
                  ),

                  const SizedBox(height: 16),

                  /// LAST NAME
                  buildField(

                    controller:
                    lastNameController,

                    hint:
                    "Last Name",
                  ),

                  const SizedBox(height: 16),

                  /// EMAIL
                  buildField(

                    controller:
                    emailController,

                    hint: "Email",

                    keyboardType:
                    TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// CONTACT
                  buildField(

                    controller:
                    contactController,

                    hint:
                    "Contact Number",

                    keyboardType:
                    TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  /// MESSAGE
                  buildField(

                    controller:
                    messageController,

                    hint: "Message",

                    maxLines: 5,
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  SizedBox(

                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton(

                      onPressed: () {

                        final data = {

                          "first_name":
                          firstNameController.text,

                          "last_name":
                          lastNameController.text,

                          "email":
                          emailController.text,

                          "contact":
                          contactController.text,

                          "message":
                          messageController.text,
                        };
                        print(data);
                      },

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        const Color(0xFF0A4DA2),

                        shape:
                        RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(

                        "SUBMIT",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 16,

                          fontFamily: "InterBold",
                        ),
                      ),
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

  Widget buildField({

    required TextEditingController
    controller,

    required String hint,

    int maxLines = 1,

    TextInputType keyboardType =
        TextInputType.text,

  }) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      keyboardType: keyboardType,

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(

          fontFamily: "InterMedium",

          color: Colors.grey,
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding:
        const EdgeInsets.symmetric(

          horizontal: 16,

          vertical: 18,
        ),

        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

