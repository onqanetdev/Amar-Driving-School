import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../bloc/common/invoice/user_invoice_dart.dart';
import '../../../bloc/common/invoice/user_invoice_event.dart';
import '../../../bloc/common/invoice/user_invoice_state.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../common/app_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/StudentModel.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';



class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() =>
      _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  final nameController = TextEditingController();
  final fileController = TextEditingController();

  List<StudentData> students = [];
  StudentData? selectedStudent;


  @override
  void initState() {
    super.initState();
    fetchStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      //Student List Bloc Listener
      BlocListener<InstructorStudentListBloc, InstructorStudentListState>(
      listener: (context, state) {

        if(state
        is InstructorStudentListLoading) {

          LoaderHelper.show(context);
        }

        if (state is InstructorStudentListSuccess) {

          LoaderHelper.hide(context);

          setState(() {
            students = state.studentListResponse.data;
          });
        }

        if(state
        is InstructorStudentListFailure) {

          LoaderHelper.hide(context);

          Helper.showToast(
            context,
            state.error,
          );
        }
      },
      ),

      // BlocListener<UserInvoiceBloc, UserInvoiceState>(
      //
      //   listener: (context, state) {
      //
      //     if (state is UserInvoiceLoading) {
      //
      //       LoaderHelper.show(context);
      //     }
      //
      //     if (state is UserInvoiceSuccess) {
      //
      //       LoaderHelper.hide(context);
      //
      //       Helper.showToast(
      //         context,
      //         state.userInvoiceResponse.message,
      //       );
      //
      //       print(
      //         state.userInvoiceResponse.path,
      //       );
      //     }
      //
      //     if (state is UserInvoiceFailure) {
      //
      //       LoaderHelper.hide(context);
      //
      //       Helper.showToast(
      //         context,
      //         state.error,
      //       );
      //     }
      //   },
      // ),

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
              final response = await http.get(Uri.parse(invoiceUrl));

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

              /// 🔹 HEADER
              AppHeader(
                title: "Upload Training Report",
                showBack: true,
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [

                    /// 🔹 CARD
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Column(
                        children: [

                          /// 🔹 STUDENT DROPDOWN
                          AppInputField(
                            controller: nameController,
                            hintText: "Student Name",
                            readOnly: true,            // 🔥 disable typing
                            onTap: showStudentList,    // 🔥 open dialog

                            fillColor: AppColor.colorInputBg,
                            borderColor: AppColor.colorInputBorder,
                            focusedBorderColor: AppColor.colorInputFocusBorder,
                            hintColor: AppColor.colorInputHint,

                            suffixWidget: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// 🔹 SUBMIT BUTTON
                          AppButton(
                            text: "SUBMIT",
                            onTap: onSubmit,
                            textStyle: const TextStyle(
                              fontFamily: "InterBold",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );

  }

  /// 🔥 STUDENT BOTTOM SHEET
  void showStudentList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [

              /// 🔹 HANDLE + CLOSE
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [

                    Expanded(
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
              ),

              /// 🔹 TITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Student",
                    style: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 STUDENT LIST
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStudent = student;
                          nameController.text = student.name;
                        });
                        print("Selected Name => ${nameController.text}");
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [

                            /// 🔹 AVATAR
                            const CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.person, size: 18),
                            ),

                            const SizedBox(width: 10),

                            /// 🔹 DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontFamily: "InterBold",
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    student.phone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 🔹 AMOUNT
                            Text(
                              "₹${student.amount}",
                              style: const TextStyle(
                                fontFamily: "InterBold",
                                color: Color.fromARGB(
                                    255, 54, 113, 232),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔥 FILE PICK
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'], // 🔥 customize
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      setState(() {
        fileController.text = file.name; // 👈 show file name
      });

      /// 🔥 optional: get path
      String? filePath = file.path;

      print("Selected File: $filePath");
    } else {
      print("No file selected");
    }
  }

  /// 🔥 SUBMIT
  void onSubmit() {
    print("Selected Student detials: ${selectedStudent?.userId ?? ''}");

    context.read<UserInvoiceBloc>().add(
      UserInvoiceTapped(
        stdId: selectedStudent?.userId ?? '',
      ),
    );
  }

  Future<void> fetchStudentList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    context.read<InstructorStudentListBloc>().add(
      FetchInstructorStudentList(
        instructureId: userId!,
      ),
    );
  }
}