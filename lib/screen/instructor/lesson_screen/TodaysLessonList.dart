
import 'package:amar_driving_school/bloc/instructor/todays_lesson/instructor_todays_lesson_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/todays_lesson/instructor_todays_lesson_state.dart';
import 'package:flutter/material.dart';
import '../../../bloc/instructor/create_lesson/instructor_create_lesson_bloc.dart';
import '../../../bloc/instructor/lesson_edit/instructor_lesson_edit_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import '../../../bloc/instructor/todays_lesson/instructor_todays_lesson_event.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../model/RatingItem.dart';
import '../../../model/instructor_todays_lesson_model/instructor_todays_lesson_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../add_lesson_screen/AddLessonScreen.dart';
import '../lesson_give_rating_screen/LessonGiveRatingScreen.dart';

class Todayslessonlist extends StatefulWidget {
  final bool showBack;
  const Todayslessonlist({super.key, this.showBack = false});

  @override
  State<Todayslessonlist> createState() => _TodayslessonlistState();
}

class _TodayslessonlistState extends State<Todayslessonlist> {

  List<TodaysLessonData> lessons = [];

  //This Section is for Load more
  final ScrollController _scrollController = ScrollController();

  int offset = 0;
  int limit = 30;

  bool isLoadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();

    fetchLessonList();

    //This Section is also for scrollView
    // _scrollController.addListener(() {
    //
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 200 &&
    //       !isLoadingMore &&
    //       hasMore) {
    //
    //     loadMoreLessons();
    //   }
    // });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocListener(

        listeners: [

          /// LESSON LIST
          BlocListener<InstructorTodaysLessonBloc, InstructorTodaysLessonState>(

            listener: (context, state) {

              /// LOADING
              if(state is InstructorTodaysLessonLoading) {

                LoaderHelper.show(context);
              }

              /// SUCCESS
              if(state is InstructorTodaysLessonSuccess) {

                LoaderHelper.hide(context);

                setState(() {

                  if(offset == 0) {

                    lessons.clear();
                  }

                  lessons.addAll(

                    state.todaysLessonResponse.data,
                  );

                  isLoadingMore = false;

                  if(state.todaysLessonResponse.data
                      .length < limit) {

                    hasMore = false;
                  }
                });
              }

              /// FAILURE
              if(state is InstructorTodaysLessonFailure) {

                LoaderHelper.hide(context);

                //Helper.showToast(context, state.error,);
              }
            },
          ),

          /// DELETE LESSON
          // BlocListener<InstructorLessonDeleteBloc, InstructorLessonDeleteState>(
          //
          //   listener: (context, state) {
          //
          //     /// LOADING
          //     if(state is InstructorLessonDeleteLoading) {
          //
          //       LoaderHelper.show(context);
          //     }
          //
          //     /// SUCCESS
          //     if(state is InstructorLessonDeleteSuccess) {
          //
          //       print("DELETE SUCCESS");
          //
          //       LoaderHelper.hide(context);
          //
          //       Helper.showToast(
          //
          //         context,
          //
          //         state.deleteResponse.message,
          //       );
          //
          //
          //       /// REFRESH LIST
          //       //lessons.clear();
          //
          //       setState(() {
          //         lessons.clear();
          //       });
          //
          //       fetchLessonList();
          //       //fetchLessonList();
          //     }
          //
          //     /// FAILURE
          //     if(state is InstructorLessonDeleteFailure) {
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
        ],

        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            Navigator.pop(context, true);
          },
          child: Scaffold(
            backgroundColor: Color(0xFFE9E9E9),

            body: Column(
              children: [
                /// HEADER
                AppHeader(
                  title: "Lesson",
                  showBack: widget.showBack,
                  onBack: (){
                    Navigator.pop(context, true);
                  },
                  showAddButton: false,
                ),
                SizedBox(height: 10,),
                Expanded(
                  child: lessons.isEmpty
                      ? const Center(
                    child: Text(
                      "No Lesson Found!",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "InterSemiBold",
                      ),
                    ),
                  )
                      :
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final data = lessons[index];

                      return Container(
                        width: MediaQuery.of(context).size.width * 0.85, // 🔥 card width
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 1, 70, 148),
                              Color.fromARGB(255, 1, 9, 20)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            /// PROFILE
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 217, 217, 217),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(
                                'assets/app_icons/user_black.png',
                                color: Color.fromARGB(255, 122, 122, 122),
                              ),
                            ),

                            SizedBox(width: 8),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Text("Student name: ",
                                          style: TextStyle(color: Colors.white)),
                                      Expanded(
                                        child: Text(
                                          data.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: HexColor(AppColor.colorOfToday),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    "Topic: ${data.name}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),

                                  Text(
                                    "Date: ${data.lessonStart}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  // ListView.separated(
                  //
                  //   controller: _scrollController,
                  //
                  //   padding: EdgeInsets.all(10),
                  //
                  //   itemCount: lessons.length + (hasMore ? 1 : 0),
                  //
                  //   separatorBuilder: (_, __) => SizedBox(height: 12),
                  //
                  //   itemBuilder: (context, index) {
                  //
                  //     if(index == lessons.length) {
                  //
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 20),
                  //         child: Center(
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       );
                  //     }
                  //
                  //     return InkWell(
                  //       onTap: () {
                  //         //print("Tapped ${lessons[index].name}");
                  //
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (_) => MultiBlocProvider(
                  //         //       providers: [
                  //         //
                  //         //         BlocProvider(
                  //         //           create: (_) => InstructorTopicListBloc(),
                  //         //         ),
                  //         //
                  //         //         BlocProvider(
                  //         //           create: (_) => InstructorSubTopicListBloc(),
                  //         //         ),
                  //         //
                  //         //         BlocProvider(
                  //         //           create: (_) => InstructorStudentListBloc(),
                  //         //         ),
                  //         //
                  //         //         BlocProvider(
                  //         //           create: (_) => InstructorCreateLessonBloc(),
                  //         //         ),
                  //         //
                  //         //         BlocProvider(
                  //         //           create: (_) => InstructorLessonEditBloc(),
                  //         //         ),
                  //         //       ],
                  //         //       child: AddLessonScreen(
                  //         //         lesson: lessons[index],
                  //         //       ),
                  //         //     ),
                  //         //   ),
                  //         // );
                  //
                  //       },
                  //       child: LessonCard(data: lessons[index],
                  //         onRatingSubmitted: () {
                  //
                  //           setState(() {
                  //             lessons.clear();
                  //           });
                  //
                  //           fetchLessonList();
                  //         },
                  //       ),
                  //     );
                  //
                  //     // LessonCard(data: lessons[index]);
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        )
    );

  }

  Future<void> fetchLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    setState(() {
      lessons.clear();
      offset = 0;
      limit = 30;
      hasMore = true;
      isLoadingMore = false;
    });

    //
    // offset = 0;
    // hasMore = true;

    context.read<InstructorTodaysLessonBloc>().add(

      FetchInstructorTodaysLesson(

        instructorId: userId.toString(),

        // limit: limit.toString(),
        //
        // offset: offset.toString(),
      ),
    );
  }


}


