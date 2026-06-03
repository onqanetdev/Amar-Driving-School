import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../common/app_color.dart';
import '../../../model/StudentModel.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() =>
      _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  final nameController = TextEditingController();
  final fileController = TextEditingController();

  ///  STUDENT LIST (MODEL)
  // List<StudentModel> students = [
  //   StudentModel(
  //     name: "Ravi Kumar",
  //     email: "ravi@gmail.com",
  //     phone: "9876543210",
  //     duration: "4 to 6 month",
  //     date: "18.04.2026",
  //     amount: 1840,
  //   ),
  //   StudentModel(
  //     name: "Amit Sharma",
  //     email: "amit@gmail.com",
  //     phone: "9123456780",
  //     duration: "3 month",
  //     date: "10.03.2026",
  //     amount: 1500,
  //   ),
  // ];
  //
  // StudentModel? selectedStudent;

  List<StudentData> students = [];
  StudentData? selectedStudent;


  @override
  void initState() {
    super.initState();
    fetchStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstructorStudentListBloc, InstructorStudentListState>(
      listener: (context, state) {

        if (state is InstructorStudentListSuccess) {

          setState(() {
            students = state.studentListResponse.data;
          });
        }
      },
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


    //   Scaffold(
    //   backgroundColor: const Color(0xFFE9E9E9),
    //
    //   body: Column(
    //     children: [
    //
    //       /// 🔹 HEADER
    //       AppHeader(
    //         title: "Upload Training Report",
    //         showBack: true,
    //       ),
    //
    //       Expanded(
    //         child: ListView(
    //           padding: const EdgeInsets.all(12),
    //           children: [
    //
    //             /// 🔹 CARD
    //             Container(
    //               padding: const EdgeInsets.all(15),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(20),
    //               ),
    //
    //               child: Column(
    //                 children: [
    //
    //                   /// 🔹 STUDENT DROPDOWN
    //                   AppInputField(
    //                     controller: nameController,
    //                     hintText: "Student Name",
    //                     readOnly: true,            // 🔥 disable typing
    //                     onTap: showStudentList,    // 🔥 open dialog
    //
    //                     fillColor: AppColor.colorInputBg,
    //                     borderColor: AppColor.colorInputBorder,
    //                     focusedBorderColor: AppColor.colorInputFocusBorder,
    //                     hintColor: AppColor.colorInputHint,
    //
    //                     suffixWidget: const Icon(
    //                       Icons.keyboard_arrow_down,
    //                       color: Colors.grey,
    //                     ),
    //                   ),
    //
    //                   const SizedBox(height: 15),
    //
    //                   /// 🔹 SUBMIT BUTTON
    //                   AppButton(
    //                     text: "SUBMIT",
    //                     onTap: onSubmit,
    //                     textStyle: const TextStyle(
    //                       fontFamily: "InterBold",
    //                       fontSize: 12,
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
    final data = {
      "student_name": selectedStudent?.name,
      "student_phone": selectedStudent?.phone,
      "file": fileController.text,
    };

    print(data);
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