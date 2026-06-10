import 'dart:io';

import 'package:amar_driving_school/bloc/instructor/student_list/instructor_student_list_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/upload_training_report/instructor_upload_training_report_bloc.dart';
import '../../../bloc/instructor/upload_training_report/instructor_upload_training_report_event.dart';
import '../../../bloc/instructor/upload_training_report/instructor_upload_training_report_state.dart';
import '../../../common/app_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadTrainingScreen extends StatefulWidget {
  final String? studentName;
  final String? studentCode;
  const UploadTrainingScreen({super.key, this.studentName, this.studentCode});

  @override
  State<UploadTrainingScreen> createState() =>
      _UploadTrainingScreenState();
}

class _UploadTrainingScreenState extends State<UploadTrainingScreen> {

  final nameController = TextEditingController();
  final fileController = TextEditingController();



  List<StudentData> students = [];

  StudentData? selectedStudent;
  File? selectedFile;

  @override
  void initState() {
    super.initState();

    if (widget.studentName != null && widget.studentCode != null) {

      nameController.text = widget.studentName!;
    } else {
      fetchStudentList();
    }
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocListener(

      listeners: [

        /// STUDENT LISTENER
        BlocListener<
            InstructorStudentListBloc,
            InstructorStudentListState>(

          listener: (context, state) {

            if(state
            is InstructorStudentListLoading) {

              LoaderHelper.show(context);
            }

            if(state
            is InstructorStudentListSuccess) {

              LoaderHelper.hide(context);

              students =
                  state.studentListResponse.data;
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

        /// UPLOAD REPORT LISTENER
        BlocListener<InstructorUploadTrainingReportBloc, InstructorUploadTrainingReportState>(

          listener: (context, state) {

            /// LOADING
            if(state is InstructorUploadTrainingReportLoading) {

              LoaderHelper.show(context);
            }

            /// SUCCESS
            if(state
            is InstructorUploadTrainingReportSuccess) {

              LoaderHelper.hide(context);

              Helper.showToast(

                context,

                state.response.message,
              );

              Navigator.pop(context);
            }

            /// FAILURE
            if(state
            is InstructorUploadTrainingReportFailure) {

              LoaderHelper.hide(context);

              Helper.showToast(
                context,
                state.error,
              );
            }
          },
        ),
      ],

      child:  Scaffold(
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
                          //onTap: showStudentList,    // 🔥 open dialog
                          onTap: (widget.studentName != null &&
                              widget.studentCode != null)
                              ? null
                              : showStudentList,
                          fillColor: AppColor.colorInputBg,
                          borderColor: AppColor.colorInputBorder,
                          focusedBorderColor: AppColor.colorInputFocusBorder,
                          hintColor: AppColor.colorInputHint,
                          suffixWidget: (widget.studentName != null &&
                              widget.studentCode != null)
                              ? const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )
                              : const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          // suffixWidget: const Icon(
                          //   Icons.keyboard_arrow_down,
                          //   color: Colors.grey,
                          // ),
                        ),

                        const SizedBox(height: 10),

                        /// 🔹 FILE UPLOAD FIELD (FIXED)
                        AppInputField(
                          controller: fileController,
                          hintText: "Upload Training Report",
                          readOnly: true,            // 🔥 no typing
                          onTap: pickFile,           // 🔥 open picker

                          fillColor: AppColor.colorInputBg,
                          borderColor: AppColor.colorInputBorder,
                          focusedBorderColor: AppColor.colorInputFocusBorder,
                          hintColor: AppColor.colorInputHint,

                          suffixWidget: GestureDetector(
                            onTap: pickFile,
                            child: const Icon(
                              Icons.upload_outlined,
                              color: Colors.grey,
                            ),
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

  Future<void> fetchStudentList() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    print(userId);

    context.read<InstructorStudentListBloc>().add(

      FetchInstructorStudentList(
        instructureId: userId!,
      ),
    );
  }

  /// 🔥 FILE PICK
  void pickFile() async {

    FilePickerResult? result =
    await FilePicker.platform.pickFiles(

      type: FileType.custom,

      allowedExtensions: [
        'pdf',
        'jpg',
        'png',
      ],
    );

    if (result != null &&
        result.files.isNotEmpty) {

      final file =
          result.files.first;

      /// SAVE FILE
      selectedFile =
          File(file.path!);

      setState(() {

        fileController.text =
            file.name;
      });

      print(
        "Selected File: ${selectedFile!.path}",
      );

    } else {

      print("No file selected");
    }
  }

  /// 🔥 SUBMIT
  void onSubmit() {
    // final data = {
    //   "student_name": selectedStudent?.name,
    //   "student_phone": selectedStudent?.phone,
    //   "file": fileController.text,
    // };
    //
    // print(data);

    /// VALIDATION
    if(selectedStudent == null) {

      Helper.showToast(

        context,

        "Please select student",
      );

      return;
    }

    if(selectedFile == null) {

      Helper.showToast(

        context,

        "Please upload report",
      );

      return;
    }

    /// CALL EVENT
    context.read<InstructorUploadTrainingReportBloc>().add(
      UploadTrainingReport(
        studentId: widget.studentCode ?? selectedStudent!.userId,
        status: "1",
        reportFile: selectedFile!,
      ),
    );
  }
}