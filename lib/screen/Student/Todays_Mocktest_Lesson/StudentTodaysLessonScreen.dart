
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_bloc.dart';
import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_event.dart';
import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../model/student_all_model/student_todays_lesson_list_model.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Studenttodayslessonscreen extends StatefulWidget {
  final bool showBack;
  const Studenttodayslessonscreen({super.key, required this.showBack});

  @override
  State<Studenttodayslessonscreen> createState() => _StudenttodayslessonscreenState();
}

class _StudenttodayslessonscreenState extends State<Studenttodayslessonscreen> {

  List<StudentTodaysLessonData> lessons = [];

  //This Section is for Load more
  final ScrollController _scrollController = ScrollController();

  int offset = 0;
  int limit = 30;

  bool isLoadingMore = false;
  bool hasMore = true;
  bool isLessonLoading = true;

  @override
  void initState() {
    super.initState();

    fetchLessonList();
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

        /// TODAY'S LESSON LIST
        BlocListener<StudentTodaysLessonListBloc, StudentTodaysLessonListState>(

    listener: (context, state) {

      /// LOADING
      if(state is StudentTodaysLessonListLoading) {
        //LoaderHelper.show(context);
        isLessonLoading = true;
      }

      /// SUCCESS
      if(state is StudentTodaysLessonListSuccess) {
        // LoaderHelper.hide(context);
        isLessonLoading = false;
        print('Lesson List ----->${state.todaysLessonListResponse.data}');
        setState(() {
          lessons = state.todaysLessonListResponse.data;
        });

        print("Lesson List Length = ${lessons.length}",);
      }

      /// FAILURE
      if(state is StudentTodaysLessonListFailure) {
        //LoaderHelper.hide(context);
        isLessonLoading = false;
        print(state.error);
      }
    },
    ),
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
                  child: isLessonLoading
                      ? _mocktestShimmer()
                      : lessons.isEmpty
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
                        //margin: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                          data.name ?? '',
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
                ),
              ],
            ),
          ),
        )
    );

  }

  Future<void> fetchLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('stud_user_id');

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

    context.read<StudentTodaysLessonListBloc>().add(

      FetchStudentTodaysLessonList(

        studentCode: userId.toString(),

        // limit: limit.toString(),
        //
        // offset: offset.toString(),
      ),
    );
  }

  //Shimmer Effect


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
}
