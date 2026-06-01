import 'package:amar_driving_school/screen/instructor/add_lesson_screen/AddLessonScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/student/lesson_list/student_lesson_list_bloc.dart';
import '../../../bloc/student/lesson_list/student_lesson_list_event.dart';
import '../../../bloc/student/lesson_list/student_lesson_list_state.dart';
import '../../../bloc/student/lesson_review/student_lesson_review_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/LessonModel.dart';
import '../../../model/student_all_model/student_lesson_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../lesson_report_screen/LessonReportScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class LessonScreen extends StatefulWidget {
  final bool showBack;
  LessonScreen({super.key,this.showBack = false});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {

  // final List<LessonModel> lessons = List.generate(
  //   5,
  //   (index) => LessonModel(
  //     name: "Pre-Drive Checks",
  //     topic: "Vehicle approach",
  //     duration: "1hr",
  //     date: "18.04.2026",
  //     time: "10:30AM",
  //   ),
  // );


   List<StudentLessonData> lessons = [];

   bool isLessonLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentLessonList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners:[
      BlocListener<StudentLessonListBloc, StudentLessonListState>(

        listener: (context, state) {

          if(state is StudentLessonListLoading) {
           // LoaderHelper.show(context);

            setState(() {

              isLessonLoading = true;
            });

          }

          if(state is StudentLessonListSuccess) {

            //LoaderHelper.hide(context);

            setState(() {
              isLessonLoading = false;
              lessons = state.lessonListResponse.data;
            });

            print(
              "Student Lesson List => "
                  "${lessons.length}",
            );
          }

          if(state is StudentLessonListFailure) {

            setState(() {

              isLessonLoading = false;
            });

            print(state.error);
          }
        },
      ),
    ],
        child: Scaffold(
          backgroundColor: Color(0xFFE9E9E9),

          body: Column(
            children: [
              /// HEADER
              AppHeader(
                title: "Lesson",
                showBack: widget.showBack,
                showAddButton: false,
              ),

              /// LIST
              Expanded(
                child:
                isLessonLoading

                    ? _lessonShimmer()

                    : lessons.isEmpty

                    ? Card(

                  elevation: 3,

                  margin: const EdgeInsets.all(16),

                  shape: RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(12),
                  ),

                  child: const Padding(

                    padding: EdgeInsets.all(20),

                    child: Center(

                      child: Text(

                        "No Lesson Found!",

                        style: TextStyle(

                          fontSize: 16,

                          fontFamily:
                          "InterSemiBold",
                        ),
                      ),
                    ),
                  ),
                ) : ListView.separated(
                  padding: EdgeInsets.all(10),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return LessonCard(data: lessons[index]);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

  Future<void> fetchStudentLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final studentCode =
        prefs.getString("stud_user_id") ?? "";

    context.read<StudentLessonListBloc>().add(

      FetchStudentLessonList(

        studentId: studentCode,

        limit: "10",

        offset: "0",
      ),
    );
  }

   // Widget _lessonShimmer() {
   //   return SizedBox(
   //     height: 100,
   //     child: ListView.builder(
   //       scrollDirection: Axis.horizontal,
   //       itemCount: 2,
   //       itemBuilder: (context, index) {
   //         return buildShimmerLesson();
   //       },
   //     ),
   //   );
   // }

   Widget _lessonShimmer() {

     return ListView.separated(

       padding: const EdgeInsets.all(16),

       itemCount: 5,

       separatorBuilder: (_, __) =>
       const SizedBox(height: 12),

       itemBuilder: (_, __) {

         return Shimmer.fromColors(

           baseColor: Colors.grey.shade300,

           highlightColor:
           Colors.grey.shade100,

           child: Container(

             padding:
             const EdgeInsets.all(16),

             decoration: BoxDecoration(

               color: Colors.white,

               borderRadius:
               BorderRadius.circular(16),
             ),

             child: Column(

               crossAxisAlignment:
               CrossAxisAlignment.start,

               children: [

                 /// TITLE
                 Container(

                   height: 16,

                   width: 140,

                   decoration: BoxDecoration(

                     color: Colors.white,

                     borderRadius:
                     BorderRadius.circular(4),
                   ),
                 ),

                 const SizedBox(height: 12),

                 /// DATE ROW
                 Row(

                   children: [

                     Container(

                       height: 12,

                       width: 80,

                       decoration:
                       BoxDecoration(

                         color: Colors.white,

                         borderRadius:
                         BorderRadius.circular(4),
                       ),
                     ),

                     const SizedBox(width: 20),

                     Container(

                       height: 12,

                       width: 60,

                       decoration:
                       BoxDecoration(

                         color: Colors.white,

                         borderRadius:
                         BorderRadius.circular(4),
                       ),
                     ),
                   ],
                 ),

                 const SizedBox(height: 12),

                 /// BOTTOM ROW
                 Row(

                   mainAxisAlignment:
                   MainAxisAlignment.spaceBetween,

                   children: [

                     Container(

                       height: 12,

                       width: 70,

                       decoration:
                       BoxDecoration(

                         color: Colors.white,

                         borderRadius:
                         BorderRadius.circular(4),
                       ),
                     ),

                     Container(

                       height: 24,

                       width: 24,

                       decoration:
                       const BoxDecoration(

                         color: Colors.white,

                         shape: BoxShape.circle,
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           ),
         );
       },
     );
   }


   Widget buildShimmerLesson() {
     return Container(
       width: MediaQuery.of(context).size.width,
       margin: const EdgeInsets.only(right: 10),
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: HexColor("${AppColor.colorWhite}"),
         borderRadius: BorderRadius.circular(10),
         boxShadow: [
           BoxShadow(
             color: HexColor(
               "${AppColor.colorAppGray}",
             ).withOpacity(0.3),
             blurRadius: 6,
             offset: const Offset(0, 1),
           ),
         ],
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               Shimmer.fromColors(
                 baseColor: Colors.grey[400]!,
                 highlightColor: Colors.grey[100]!,
                 child: Container(width: 16, height: 16, color: Colors.grey.shade400),
               ),
               const SizedBox(width: 5),
               Shimmer.fromColors(
                 baseColor: Colors.grey[400]!,
                 highlightColor: Colors.grey[100]!,
                 child: Container(width: 60, height: 14, color: Colors.grey.shade400),
               ),
               const Spacer(),
               Shimmer.fromColors(
                 baseColor: Colors.grey[400]!,
                 highlightColor: Colors.grey[100]!,
                 child: Container(width: 14, height: 14, color: Colors.grey.shade400),
               ),
             ],
           ),
           const SizedBox(height: 8),
           Shimmer.fromColors(
             baseColor: Colors.grey[400]!,
             highlightColor: Colors.grey[100]!,
             child: Container(width: 100, height: 14, color: Colors.grey.shade400),
           ),
           const SizedBox(height: 6),
           Shimmer.fromColors(
             baseColor: Colors.grey[400]!,
             highlightColor: Colors.grey[100]!,
             child: Container(width: double.infinity, height: 14, color: Colors.grey.shade400),
           ),
         ],
       ),
     );
   }

}

class LessonCard extends StatelessWidget {
  final StudentLessonData data;

  const LessonCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      data.name ?? 'No Name',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "InterBold",
                        color: HexColor("${AppColor.colourOfAdvanceCarDrive}"),
                      ),
                    ),

                    SizedBox(height: 6),

                    /// DURATION
                    Row(
                      children: [
                        Text(
                          "Lesson Duration: ",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "InterSemiBold",
                            color: HexColor(AppColor.colorAppGray),
                          ),
                        ),
                        Text(
                          data.lessonDuration ?? "Duration not found",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "InterSemiBold",
                            color: HexColor("${AppColor.colorOfEditColour}"),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),

                    /// DATE + TIME
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14,
                                color: HexColor(AppColor.colorAppGray)),
                            SizedBox(width: 2),
                            Text(
                              //data.date,
                              data.lessonStart ?? '',
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorOfEditColour),
                                fontFamily: "InterSemiBold",),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14,
                                color: HexColor(AppColor.colorAppGray)),
                            SizedBox(width: 2),
                            Text(
                             // data.time.toString(),
                              data.classDate ?? 'no date' ,
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorOfEditColour),
                                fontFamily: "InterSemiBold",),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10),

              /// RIGHT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// EDIT DELETE

                  SizedBox(height: 30),

                  /// BUTTON
                  AppButton(
                    height: 34,
                    text: "Lesson Report",
                    onTap: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(

                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) => StudentLessonReviewBloc(),
                                ),
                              ],

                              child: const LessonReportScreen(),
                            ),
                          ),
                      );
                    },
                    textStyle: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
            "Delete Lesson",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "InterBold",
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Are you sure you want to delete this lesson?",
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
                    Navigator.pop(context);
                    Helper.showToast(context, "Deleted successfully");
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
