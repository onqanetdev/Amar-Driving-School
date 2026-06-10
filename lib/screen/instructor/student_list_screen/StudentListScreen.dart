import 'package:amar_driving_school/bloc/instructor/lesson_edit/instructor_lesson_edit_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/lesson_list/instructor_lesson_list_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_edit/instructor_update_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_list_bloc.dart';
import 'package:amar_driving_school/bloc/student/lesson_list/student_lesson_list_bloc.dart';
import 'package:amar_driving_school/bloc/student/lesson_review/student_lesson_review_bloc.dart';
import 'package:amar_driving_school/bloc/student/mocktest_list/student_mocktest_list_bloc.dart';
import 'package:amar_driving_school/common/app_color.dart';
import 'package:amar_driving_school/common/convert_color.dart';
import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/screen/instructor/mock_test_reports_screen/MockTestReportsScreen.dart';
import 'package:amar_driving_school/screen/instructor/mock_test_screen/MockTestScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/add_student/instructor_add_student_bloc.dart';
import '../../../bloc/instructor/add_student/instructor_add_student_state.dart';

import '../../../bloc/instructor/delete_student/instructor_student_delete_bloc.dart';
import '../../../bloc/instructor/delete_student/instructor_student_delete_event.dart';
import '../../../bloc/instructor/delete_student/instructor_student_delete_state.dart';
import '../../../bloc/instructor/lesson_delete/instructor_lesson_delete_bloc.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../bloc/instructor/update_student_information/instructor_student_update_bloc.dart';
import '../../../bloc/instructor/upload_training_report/instructor_upload_training_report_bloc.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_bloc.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/StudentModel.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../widgets/app_header.dart';
import '../add_student_screen/AddStudentScreen.dart';
import '../lesson_report_screen/LessonReportScreen.dart';
import '../lesson_screen/LessonScreen.dart';
import '../lesson_screen/StudentWiseLessonScreen.dart';
import '../mock_test_screen/StudentWiseMocktestScreen.dart';
import '../upload_training_screen/UploadTrainingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentListScreen extends StatefulWidget {
  StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

   List<StudentData> students = [];
   bool isStudentDeleted = false;

  @override
  void initState() {
    super.initState();

    fetchStudentList();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocListener(listeners: [

      /// ADD STUDENT
      BlocListener<InstructorAddStudentBloc, InstructorAddStudentState>(
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

            Navigator.pop(context,true);
          }

          if(state is InstructorAddStudentFailure) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      ),

      /// DELETE STUDENT
      BlocListener<InstructorStudentDeleteBloc, InstructorStudentDeleteState>(

        listener: (context, state) {

          if(state is InstructorStudentDeleteLoading) {

            LoaderHelper.show(context);
          }

          if(state is InstructorStudentDeleteSuccess) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.deleteResponse.message,
            );

            isStudentDeleted = true;

            /// REFRESH LIST
            fetchStudentList();
          }

          if(state is InstructorStudentDeleteFailure) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      ),

    ],

        child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, isStudentDeleted);
              return false;
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
            onBack: () {
              Navigator.pop(context, isStudentDeleted);
            },
            onAdd: () {
              showAddStudentDialog(context);
            },
          ),



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

                  students = state.studentListResponse.data;

                  if(students.isEmpty) {

                    return const Center(
                      child: Text("No Students Found"),
                    );
                  }

                  return ListView.separated(

                    padding: const EdgeInsets.all(10),

                    itemCount: state.studentListResponse.data.length,

                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),

                    itemBuilder: (context, index) {

                      final data = state.studentListResponse.data[index];

                      return StudentCard(
                        data: data,
                        onRefresh: fetchStudentList,
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
    )
        )
    );
  }



   Future<void> showAddStudentDialog(
       BuildContext parentContext,
       ) async {

     final result = await showDialog<bool>(
       context: parentContext,
       barrierDismissible: false,
       builder: (_) {
         return
           MultiBlocProvider(
             providers: [

               /// Existing Add Student Bloc
               BlocProvider.value(
                 value: BlocProvider.of<InstructorAddStudentBloc>(
                   parentContext,
                 ),
               ),

               /// Student Update Bloc
               BlocProvider(
                 create: (_) => InstructorStudentUpdateBloc(),
               ),

             ],
             child: Dialog(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20),
               ),
               child: AddStudentScreen(),
             ),
           );
       },
     );

     if (result == true) {
       fetchStudentList();
     }
   }

  Future<void> fetchStudentList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    //print("Instructor Id 🌐🌐🌐${userId}");

    context.read<InstructorStudentListBloc>().add(

      FetchInstructorStudentList(
        instructureId: userId!,
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final StudentData data;
  final VoidCallback onRefresh;
  const StudentCard({super.key, required this.data, required this.onRefresh});

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

                    Text("Login ID: ${data.loginId}",
                      style: TextStyle(
                        fontFamily: "InterMedium",
                        fontSize: 11,
                        color: HexColor("${AppColor.colorAppGrayLight}"),
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
                        onTap: () async {

                          final result = await showDialog(
                            context: context,
                            builder: (_) {
                              return MultiBlocProvider(providers: [
                                /// Add Student Bloc
                                BlocProvider.value(
                                  value: context.read<InstructorAddStudentBloc>(),
                                ),

                                /// Update Student Bloc
                                BlocProvider(
                                  create: (_) => InstructorStudentUpdateBloc(),
                                ),
                              ],

                                  child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: AddStudentScreen(
                                    student: data, // 🔥 pass data
                                  ),
                                ),
                              );
                            }

                            //     Dialog(
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: AddStudentScreen(
                            //     student: data, // 🔥 pass data
                            //   ),
                            // ),
                          );

                          if (result == true) {
                            onRefresh();
                          }
                        },
                        child:
                        Text(
                          "Edit",
                          style: TextStyle(
                            color: HexColor("${AppColor.colorOfEditColour}"),
                            fontFamily: "InterSemiBold",
                            fontSize: 13,
                          ),
                        ),
                      ),

                      //The Vertical Separator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 1,
                          height: 10,
                          color: HexColor("${AppColor.colourOfDeleteBtn}"),
                        ),
                      ),

                      //Delete Section

                      GestureDetector(
                        onTap: () {
                          print("Tapped on Deleted");
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) {
                              return _deleteBottomSheet(context);
                            },
                          );
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: HexColor("${AppColor.colourOfDeleteBtn}"),
                            fontFamily: "InterSemiBold",
                            fontSize: 13,
                          ),
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

                  // Text("Login ID: ${data.loginId}",
                  //   style: TextStyle(
                  //     fontFamily: "InterMedium",
                  //     fontSize: 11,
                  //     color: HexColor("${AppColor.colorAppGrayLight}"),
                  //   ),
                  // ),
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
                      data.assignHour ?? "",
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
                      data.startdate ?? '',
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
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(
                  //create: (_) => InstructorLessonListBloc(),
                    create: (_) => StudentLessonListBloc()
                ),
                BlocProvider(
                  create: (_) => InstructorLessonDeleteBloc(),
                ),
                BlocProvider(
                  create: (_) => InstructorLessonEditBloc(),
                ),
              ],
                  //child:  LessonScreen(showBack: true,)

                  child: Studentwiselessonscreen(
                    showBack: true,
                    studentCode: data.userId,
                    studentName: data.name,
                  ),
              )
               //   LessonScreen(),
            ),
          );
        }else if(text=="Mocktest List") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(

                  // create: (_) =>
                  //     InstructorMocktestListBloc(),
                  create: (_) => StudentMocktestListBloc(),
                ),

                BlocProvider(create: (_) => InstructorMocktestDeleteBloc(),),

                BlocProvider(create: (_) => InstructorMocktestDeleteBloc(),),

                BlocProvider(create: (_) => InstructorUpdateMocktestBloc(),),
              ],
                child: Studentwisemocktestscreen(
                  showBack: true,
                  studCode: data.userId,
                  studentName: data.name,
                ),
               // child: MockTestScreen(showBack: true,),
              )

                  //MockTestScreen(),
            ),
          );
        }else if(text=="Mocktest Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (_) => StudentMocktestReviewBloc(),
                  ),
                ], child:  MockTestReportsScreen(studentCode: data.userId,),
                ),
                  //MockTestReportsScreen(),
            ),
          );
        }else if(text=="Lesson Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(
                  create: (_) => StudentLessonReviewBloc(),
                ),
              ], child: LessonReportScreen(studentCode: data.userId,)
              )
                  //LessonReportScreen(),
            ),
          );
        }else if(text=="Upload Training Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(
                  create: (_) =>
                      InstructorStudentListBloc(),
                ),
                BlocProvider(
                  create: (_) =>
                      InstructorUploadTrainingReportBloc(),
                ),
              ],
                  child: UploadTrainingScreen()
              )

                  //UploadTrainingScreen(),
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

  Widget _deleteBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 +
            MediaQuery.of(context).viewPadding.bottom +
            MediaQuery.of(context).viewInsets.bottom, // 🔥 FULL SAFE
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// HANDLE
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete,
              color: HexColor("${AppColor.colourOfDeleteBtn}"),
              size: 26,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Delete Student",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "InterBold",
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Are you sure you want to delete this user?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              /// CANCEL
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: HexColor(AppColor.colorInputBorder),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontFamily: "InterSemiBold"),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// DELETE
              Expanded(
                child: InkWell(
                  onTap: () {
                    //Navigator.pop(context);
                    //Helper.showToast(context, "Deleted successfully");
                    Navigator.pop(context,true);
                    context.read<InstructorStudentDeleteBloc>().add(
                      InstructorStudentDeleteTapped(
                        instructorId: data.instructureId,
                        studentId: data.userId,
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: HexColor("${AppColor.colourOfDeleteBtn}"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "InterBold",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}