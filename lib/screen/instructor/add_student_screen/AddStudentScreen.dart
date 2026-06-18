import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/instructor/add_student/instructor_add_student_bloc.dart';
import '../../../bloc/instructor/add_student/instructor_add_student_event.dart';
import '../../../bloc/instructor/add_student/instructor_add_student_state.dart';
import '../../../bloc/instructor/update_student_information/instructor_student_update_bloc.dart';
import '../../../bloc/instructor/update_student_information/instructor_student_update_event.dart';
import '../../../bloc/instructor/update_student_information/instructor_student_update_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../model/StudentModel.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStudentScreen extends StatefulWidget {
  final StudentData? student; // 🔥 null = Add, data = Edit

  const AddStudentScreen({super.key, this.student});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final durationController = TextEditingController();
  final dateController = TextEditingController();
  final priceController = TextEditingController();
  final ageController = TextEditingController();

  bool isPaid = false;

  @override
  void initState() {
    super.initState();

    /// 🔥 PREFILL DATA (EDIT MODE)
    if (widget.student != null) {
      print("Student Name is: ${widget.student?.name}");
      print("Student Email is: ${widget.student?.email}");
      print("Student phone number: ${widget.student?.phone}");
      print("Assihn hour is: ${widget.student?.assignHour}");
      print("Start date is: ${widget.student?.startdate}");
      print("Amount is: ${widget.student?.amount}");
      print("Student Age: ${widget.student?.age}");
      print("Payment status: ${widget.student?.paymentStatus}");


      nameController.text = widget.student?.name ?? "";
      emailController.text = widget.student?.email ?? "";
      phoneController.text = widget.student?.phone ?? "";
      durationController.text = widget.student?.assignHour ?? "";
      dateController.text = widget.student?.startdate ?? "";
      priceController.text = widget.student?.amount?.toString() ?? "";
      ageController.text = widget.student?.age ?? "";
      isPaid = widget.student!.paymentStatus.toString().toLowerCase() == "paid";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;

    return MultiBlocListener(listeners: [

      /// ADD STUDENT
      BlocListener<InstructorAddStudentBloc, InstructorAddStudentState>(
        listener: (context, state) {

          if (state is InstructorAddStudentLoading) {
            Helper.showToast(
              context,
              "Adding Student...",
            );
          }

          if (state is InstructorAddStudentSuccess) {
            Helper.showToast(
              context,
              state.instructorStudentAddResponse.message,
            );

            Navigator.pop(context, true);
          }

          if (state is InstructorAddStudentFailure) {
            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      ),

      /// UPDATE STUDENT
      BlocListener<InstructorStudentUpdateBloc, InstructorStudentUpdateState>(
        listener: (context, state) {
          if (state is InstructorStudentUpdateLoading) {
            Helper.showToast(
              context,
              "Updating Student...",
            );
          }

          if (state is InstructorStudentUpdateSuccess) {

            print("Student Updated Sucessfully !!!!!");

            Helper.showToast(
              context,
              state.updateResponse.message,
            );

            Navigator.pop(context, true);
          }

          if (state is InstructorStudentUpdateFailure) {
            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      ),
    ],
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEdit ? "Edit Student" : "Add Student",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "InterSemiBold",
                          color: HexColor("${AppColor.colorOfEditColour}"),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close),
                    )
                  ],
                ),

                SizedBox(height: 15),

                /// INPUTS
                AppInputField(controller: nameController, hintText: "Student Name"),
                SizedBox(height: 10),

                AppInputField(controller: emailController, hintText: "Student Email Id",keyboardType: TextInputType.emailAddress,),
                SizedBox(height: 10),

                AppInputField(
                  controller: phoneController,
                  hintText: "Student Phone Number",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                SizedBox(height: 10),

               // AppInputField(controller: durationController, hintText: "Duration"),
                AppInputField(
                  controller: durationController,
                  hintText: "Duration",
                  readOnly: true,
                  onTap: pickDuration,
                  fillColor: AppColor.colorInputBg,
                  borderColor: AppColor.colorInputBorder,
                  focusedBorderColor:
                  AppColor.colorInputFocusBorder,
                  hintColor: AppColor.colorInputHint,
                  borderRadius: 10,
                  obscureText: false,
                ),

                SizedBox(height: 10),

                //AppInputField(controller: dateController, hintText: "Start Date"),

                GestureDetector(
                  onTap: () async {

                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {

                      // dateController.text =
                      // "${pickedDate.day.toString().padLeft(2, '0')}-"
                      //     "${pickedDate.month.toString().padLeft(2, '0')}-"
                      //     "${pickedDate.year}";

                      dateController.text = DateFormat('yy-MM-dd').format(pickedDate);

                    }
                  },
                  child: AbsorbPointer(
                    child: AppInputField(
                      controller: dateController,
                      hintText: "Start Date",
                      //  suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Extra New Field
                AppInputField(controller: ageController, hintText: "Age",keyboardType: TextInputType.number,),
                SizedBox(height: 10),

                AppInputField(
                  controller: priceController,
                  hintText: "Price",
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 10),

                /// 🔹 PAYMENT STATUS
                Row(
                  children: [
                    Text(
                      "Payment Status",
                      style: TextStyle(
                        fontFamily: "InterMedium",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                Row(
                  children: [

                    /// PAID
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => isPaid = true),
                        child: Row(
                          children: [

                            Transform.scale(
                              scale: 0.85, // 🔥 reduce size
                              child: Radio<bool>(
                                value: true,
                                groupValue: isPaid,
                                visualDensity: VisualDensity.compact, // 🔥 remove space
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔥 key fix
                                activeColor: Color.fromARGB(255, 54, 113, 232),
                                onChanged: (val) {
                                  setState(() => isPaid = val!);
                                },
                              ),
                            ),

                            const SizedBox(width: 4), // 🔥 controlled spacing

                            const Text(
                              "Paid",
                              style: TextStyle(fontFamily: "InterMedium"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// UNPAID
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => isPaid = false),
                        child: Row(
                          children: [

                            Transform.scale(
                              scale: 0.85,
                              child: Radio<bool>(
                                value: false,
                                groupValue: isPaid,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                activeColor: Color.fromARGB(255, 54, 113, 232),
                                onChanged: (val) {
                                  setState(() => isPaid = val!);
                                },
                              ),
                            ),

                            const SizedBox(width: 4),

                            const Text(
                              "Unpaid",
                              style: TextStyle(fontFamily: "InterMedium"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                /// BUTTON
                AppButton(
                  text: isEdit ? "UPDATE" : "SUBMIT",
                  onTap: () async {
                    if (isEdit) {
                      // update logic
                      fetchUpdateStudent();
                    } else {

                      if (nameController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter student name");
                        return;
                      }

                      if (emailController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter email");
                        return;
                      }

                      if (!Helper.isValidEmail(
                          emailController.text.trim())) {

                        Helper.showToast(context, "Enter valid email");
                        return;
                      }

                      if (phoneController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter phone number");
                        return;
                      }

                      if (phoneController.text.trim().length != 10) {

                        Helper.showToast(
                          context,
                          "Enter valid 10 digit phone number",
                        );

                        return;
                      }

                      if (ageController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter age");
                        return;
                      }

                      if (durationController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter duration");
                        return;
                      }

                      if (dateController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter start date");
                        return;
                      }

                      if (priceController.text.trim().isEmpty) {
                        Helper.showToast(context, "Enter price");
                        return;
                      }

                      // add logic
                      print('Submitted Tapped');
                      final prefs = await SharedPreferences.getInstance();

                      final userId = prefs.getString('user_id');

                      print(userId);

                      context.read<InstructorAddStudentBloc>().add(
                        InstructorAddStudentTapped(
                          name: nameController.text.trim(),
                          age: ageController.text.trim(), // 👈 add controller later if needed
                          startdate: dateController.text.trim(),
                          email: emailController.text.trim(),
                          duration: durationController.text.trim(),
                          price: priceController.text.trim(),
                          instructureid: userId!, // 👈 dynamic later
                          paymentstatus: isPaid ? "paid" : "unpaid",
                          phone: phoneController.text.trim(),
                        ),
                      );

                    }
                   // Navigator.pop(context,true);
                  },
                  textStyle: TextStyle(
                    fontFamily: "InterBold",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
    );


  }

  //Update the Student details

Future<void> fetchUpdateStudent() async {

  final prefs = await SharedPreferences.getInstance();

  final userId = prefs.getString('user_id');

  print("User Id for Instructor update ${userId}");

  print("Student Name is: ${nameController.text}");
 // print("Student Email is: ${widget.student?.email}");
  print("Student phone number: ${phoneController.text}");
  print("Assihn hour is: ${durationController.text}");
  print("Start date is: ${dateController.text}");
  print("Amount is: ${priceController.text}");
  print("Student Age: ${ageController.text}");
  print("Payment status: ${isPaid ? 'paid' : 'unpaid'}");


  context.read<InstructorStudentUpdateBloc>().add(
    SubmitInstructorStudentUpdate(
      userId: widget.student?.userId ?? '',
      name: nameController.text,
      age: ageController.text,
      startDate: dateController.text,
      phone: phoneController.text,
      duration: durationController.text,
      price: priceController.text,
      paymentStatus: isPaid ? "paid" : "unpaid",
    ),
  );
}

  Future<void> pickDuration() async {

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {

        durationController.text =
        "${picked.hour.toString().padLeft(2, '0')}:"
            "${picked.minute.toString().padLeft(2, '0')}";

      });
    }
  }
}