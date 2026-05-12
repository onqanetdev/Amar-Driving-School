import 'package:amar_driving_school/common/app_color.dart';
import 'package:amar_driving_school/common/convert_color.dart';
import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/screen/instructor/mock_test_reports_screen/MockTestReportsScreen.dart';
import 'package:amar_driving_school/screen/instructor/mock_test_screen/MockTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/add_student/instructor_add_student_bloc.dart';
import '../../../bloc/instructor/add_student/instructor_add_student_state.dart';

import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/StudentModel.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_header.dart';
import '../add_student_screen/AddStudentScreen.dart';
import '../lesson_report_screen/LessonReportScreen.dart';
import '../lesson_screen/LessonScreen.dart';
import '../upload_training_screen/UploadTrainingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentListScreen extends StatefulWidget {
  StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final List<StudentModel> students = List.generate(
    6,
        (index) => StudentModel(
      name: "Asok Sarma",
      email: "asok.sarma@gmail.com",
      phone: "700345678",
      duration: "4 to 6 month",
      date: "18.04.2026",
      amount: 1840,
    ),
  );


  @override
  void initState() {
    super.initState();

    fetchStudentList();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<InstructorAddStudentBloc, InstructorAddStudentState>(

      listener: (context, state) {

        if(state is InstructorAddStudentLoading) {

          LoaderHelper.show(context);
        }

        if(state is InstructorAddStudentSuccess) {

          LoaderHelper.hide(context);

          Helper.showToast(
            context,
            state.instructorStudentAddResponse.message,
          );

          Navigator.pop(context); // close dialog
        }

        if(state is InstructorAddStudentFailure) {

          LoaderHelper.hide(context);

          Helper.showToast(
            context,
            state.error,
          );
        }
      },

      child: Scaffold(

        backgroundColor: Color(0xFFE9E9E9),

        body: Column(
          children: [

            AppHeader(
              title: "Student List",
              showBack: true,
              showAddButton: true,
              addButtonText: "Add Student",
              onAdd: () {
                showAddStudentDialog(context);
              },
            ),

            // Expanded(
            //   child: ListView.separated(
            //     padding: EdgeInsets.all(10),
            //     itemCount: students.length,
            //     separatorBuilder: (_, __) =>
            //         SizedBox(height: 12),
            //     itemBuilder: (context, index) {
            //       return StudentCard(
            //         data: students[index],
            //       );
            //     },
            //   ),
            // )

            Expanded(

              child: BlocBuilder<InstructorStudentListBloc, InstructorStudentListState>(

                builder: (context, state) {

                  /// LOADING
                  if(state is InstructorStudentListLoading) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// SUCCESS
                  if(state is InstructorStudentListSuccess) {

                    final students =
                        state.studentListResponse.data;

                    if(students.isEmpty) {

                      return const Center(
                        child: Text("No Students Found"),
                      );
                    }

                    return ListView.separated(

                      padding: const EdgeInsets.all(10),

                      itemCount: students.length,

                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),

                      itemBuilder: (context, index) {

                        final data = students[index];

                        return StudentCard(
                          data: data,
                        );
                      },
                    );
                  }

                  /// FAILURE
                  if(state is InstructorStudentListFailure) {

                    return Center(
                      child: Text(state.error),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddStudentDialog(BuildContext parentContext) {

    showDialog(
      context: parentContext,
      barrierDismissible: false,

      builder: (_) {

        return BlocProvider.value(

          value:
          BlocProvider.of<InstructorAddStudentBloc>(
            parentContext,
          ),

          child: Dialog(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: AddStudentScreen(),
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
}

class StudentCard extends StatelessWidget {
  final StudentData data;

  const StudentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 🔥 light shadow
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4), // shadow down
          ),
        ],
      ),
      child: Column(
        children: [

          /// TOP SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// PROFILE
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(255, 217, 217, 217),
                ),
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/app_icons/user_black.png',
                  color: Color.fromARGB(255, 122, 122, 122),
                ),
              ),

              SizedBox(width: 8),

              /// LEFT SIDE (TAKES PROPER SPACE)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade, // 🔥 better than ellipsis
                      style: TextStyle(
                        color: HexColor("${AppColor.colourOfAdvanceCarDrive}"),
                        fontFamily: "InterBold",
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(Icons.email, size: 14,
                            color: HexColor(AppColor.colorAppGray)),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.email,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 12,
                              color: HexColor(AppColor.colorAppGray),
                              fontFamily: "InterSemiBold",
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2),

                    Row(
                      children: [
                        Icon(Icons.phone, size: 14,
                            color: HexColor(AppColor.colorAppGray)),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            data.phone,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 12,
                              color: HexColor("${AppColor.colorOfEditColour}"),
                              fontFamily: "InterSemiBold",
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2),

                    /// TIME + DATE (STACKED → BETTER)

                  ],
                ),
              ),

              SizedBox(width: 8),

              /// RIGHT SIDE (FIXED WIDTH 🔥)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: AddStudentScreen(
                                student: data, // 🔥 pass data
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: HexColor("${AppColor.colorOfEditColour}"),
                            fontFamily: "InterSemiBold",
                            fontSize: 13,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 1,
                          height: 10,
                          color: HexColor("${AppColor.colourOfDeleteBtn}"),
                        ),
                      ),

                      Text(
                        "Delete",
                        style: TextStyle(
                          color: HexColor("${AppColor.colourOfDeleteBtn}"),
                          fontFamily: "InterSemiBold",
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Text(
                    "₹${data.amount}",
                    style: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 15,
                      color: HexColor("${AppColor.colourOfAdvanceCarDrive}"),
                    ),
                  ),

                  Text(
                    "Including Tax",
                    style: TextStyle(
                      fontFamily: "InterMedium",
                      fontSize: 11,
                      color: HexColor("${AppColor.colorAppGrayLight}"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 53),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14,
                        color: HexColor(AppColor.colorAppGray)),
                    SizedBox(width: 2),
                    Text(
                      data.assignHour,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorAppGray),
                        fontFamily: "InterSemiBold",),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14,
                        color: HexColor(AppColor.colorAppGray)),
                    SizedBox(width: 2),
                    Text(
                      data.startdate,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorAppGray),
                        fontFamily: "InterSemiBold",),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),

          Divider(
            color: HexColor("${AppColor.colorAppGrayLight}")
                .withOpacity(0.4),
          ),

          SizedBox(height: 5),

          /// BUTTONS
          Wrap(
            spacing: 4,
            runSpacing: 8,
            children: [
              actionBtn(context,"Lesson List"),
              actionBtn(context,"Mocktest List"),
              actionBtn(context,"Lesson Report"),
              actionBtn(context,"Mocktest Report"),
              actionBtn(context,"Upload Training Report"),
            ],
          )
        ],
      ),
    );
  }

  Widget actionBtn(BuildContext context,String text) {
    return AppButtonAnimation(
      onTap: (){
        if(text=="Lesson List") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonScreen(),
            ),
          );
        }else if(text=="Mocktest List") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MockTestScreen(),
            ),
          );
        }else if(text=="Mocktest Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MockTestReportsScreen(),
            ),
          );
        }else if(text=="Lesson Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonReportScreen(),
            ),
          );
        }else if(text=="Upload Training Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadTrainingScreen(),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 54, 113, 232),
              Color.fromARGB(255, 3, 61, 175)
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: "InterMedium",
          ),
        ),
      ),
    );
  }
}