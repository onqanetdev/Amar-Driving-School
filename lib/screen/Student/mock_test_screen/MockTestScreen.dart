import 'package:amar_driving_school/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/mocktest_list/student_mocktest_list_bloc.dart';
import '../../../bloc/student/mocktest_list/student_mocktest_list_event.dart';
import '../../../bloc/student/mocktest_list/student_mocktest_list_state.dart';
import '../../../bloc/student/mocktest_real_review_list/student_real_mocktest_review_bloc.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../model/LessonModel.dart';
import '../../../model/student_all_model/student_mocktest_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../mock_test_reports_screen/MockTestReportsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MockTestScreen extends StatefulWidget {
  final bool showBack;
  MockTestScreen({super.key,this.showBack = false});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
   List<StudentMocktestData> lessons = [];

  bool isMocktestListLoading = true;

  @override
  void initState() {

    super.initState();

    fetchStudentMocktestList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<StudentMocktestListBloc, StudentMocktestListState>(

        listener: (context, state) {

          if(state is StudentMocktestListLoading) {

            setState(() {

              isMocktestListLoading = true;
            });
          }

          if(state is StudentMocktestListSuccess) {

            setState(() {

              isMocktestListLoading = false;

              lessons = state
                      .mocktestListResponse
                      .data;
            });

            print(
              "Mocktest Count => "
                  "${lessons.length}",
            );
          }

          if(state is StudentMocktestListFailure) {

            setState(() {

              isMocktestListLoading = false;
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
                title: "Mocktest",
                showBack: widget.showBack,
                showAddButton: false,
              ),

              /// LIST
              Expanded(
                child: isMocktestListLoading

                    ? _mocktestShimmer()

                    : lessons.isEmpty

                    ? emptyCard(
                  "No Mocktest Found!",
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
        )
    );

  }

  Future<void> fetchStudentMocktestList() async {

    final prefs = await SharedPreferences.getInstance();

    final studentId =
        prefs.getString("stud_user_id") ?? "";

    context.read<StudentMocktestListBloc>()
        .add(

      FetchStudentMocktestList(

        studentId: studentId,

        limit: "10",

        offset: "0",
      ),
    );
  }




   Widget _mocktestShimmer() {
     return ListView.separated(
       padding: const EdgeInsets.all(10),
       itemCount: 5,
       separatorBuilder: (_, __) => const SizedBox(height: 12),
       itemBuilder: (_, __) {
         return Container(
           padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(15),
             boxShadow: const [
               BoxShadow(
                 color: Colors.black12,
                 blurRadius: 4,
                 spreadRadius: 1,
                 offset: Offset(0, 2),
               ),
             ],
           ),
           child: Row(
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     shimmerBox(180, 16),

                     const SizedBox(height: 10),

                     Row(
                       children: [
                         shimmerBox(100, 12),
                         const SizedBox(width: 8),
                         shimmerBox(40, 12),
                       ],
                     ),

                     const SizedBox(height: 10),

                     Row(
                       children: [
                         shimmerCircle(14),
                         const SizedBox(width: 4),
                         shimmerBox(70, 12),

                         const SizedBox(width: 16),

                         shimmerCircle(14),
                         const SizedBox(width: 4),
                         shimmerBox(45, 12),
                       ],
                     ),
                   ],
                 ),
               ),

               const SizedBox(width: 10),

               shimmerButton(),
             ],
           ),
         );
       },
     );
   }


   Widget shimmerBox(double width, double height) {
     return Shimmer.fromColors(
       baseColor: Colors.grey.shade300,
       highlightColor: Colors.grey.shade100,
       child: Container(
         width: width,
         height: height,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(4),
         ),
       ),
     );
   }

   Widget shimmerCircle(double size) {
     return Shimmer.fromColors(
       baseColor: Colors.grey.shade300,
       highlightColor: Colors.grey.shade100,
       child: Container(
         width: size,
         height: size,
         decoration: const BoxDecoration(
           color: Colors.white,
           shape: BoxShape.circle,
         ),
       ),
     );
   }

   Widget shimmerButton() {
     return Shimmer.fromColors(
       baseColor: Colors.grey.shade300,
       highlightColor: Colors.grey.shade100,
       child: Container(
         width: 100,
         height: 34,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(8),
         ),
       ),
     );
   }

   Widget emptyCard(String text) {

     return Card(

       elevation: 4,

       margin: const EdgeInsets.all(16),

       shape: RoundedRectangleBorder(

         borderRadius:
         BorderRadius.circular(16),
       ),

       child: Padding(

         padding: const EdgeInsets.symmetric(

           vertical: 30,

           horizontal: 20,
         ),

         child: Center(

           child: Text(

             text,

             textAlign: TextAlign.center,

             style: const TextStyle(

               fontSize: 16,

               fontFamily: "InterSemiBold",

               color: Colors.black87,
             ),
           ),
         ),
       ),
     );
   }
}

class LessonCard extends StatelessWidget {
  final StudentMocktestData data;

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
                      data.name ?? "No Name Found",
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
                          data.duration.toString(),
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
                              data.lessonStart ?? "Start Date not Found",
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
                              data.duration.toString(),
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

                  SizedBox(height: 30),

                  /// BUTTON
                  AppButton(
                    height: 34,
                    text: "Mock Test Report",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(providers: [
                            BlocProvider(
                              create: (_) => StudentRealMocktestReviewBloc(),
                            ),
                          ], child:  MockTestReportsScreen(topicId: data.topicId,),
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
}
