import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import 'package:amar_driving_school/screen/instructor/add_lesson_screen/AddLessonScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/create_lesson/instructor_create_lesson_bloc.dart';
import '../../../bloc/instructor/lesson_list/instructor_Lesson_List_Event.dart';
import '../../../bloc/instructor/lesson_list/instructor_lesson_list_bloc.dart';
import '../../../bloc/instructor/lesson_list/instructor_lesson_list_state.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/LessonModel.dart';
import '../../../model/instructor_create_lesson_model/instructor_Lesson_List_Model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../lesson_give_rating_screen/LessonGiveRatingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonScreen extends StatefulWidget {
  final bool showBack;
  LessonScreen({super.key,this.showBack = false});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {

  List<LessonData> lessons = [];


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
    _scrollController.addListener(() {

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMore) {

        loadMoreLessons();
      }
    });

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<
        InstructorLessonListBloc,
        InstructorLessonListState>(

        listener: (context, state) {

          /// 🔥 LOADING
          if(state is InstructorLessonListLoading) {

            LoaderHelper.show(context);
          }

          /// 🔥 SUCCESS
          if(state is InstructorLessonListSuccess) {

            LoaderHelper.hide(context);

            // setState(() {
            //
            //   lessons.clear();
            //
            //   lessons.addAll(
            //     state.lessonListResponse.data,
            //   );
            //
            // });

            setState(() {

              if(offset == 0) {
                lessons.clear();
              }

              lessons.addAll(state.lessonListResponse.data);

              isLoadingMore = false;

              if(state.lessonListResponse.data.length < limit) {
                hasMore = false;
              }
            });

            Helper.showToast(
              context,
              state.lessonListResponse.message,
            );
          }

          /// 🔥 FAILURE
          if(state is InstructorLessonListFailure) {

            LoaderHelper.hide(context);

            Helper.showToast(
              context,
              state.error,
            );
          }
        },

    child:  Scaffold(
      backgroundColor: Color(0xFFE9E9E9),

      body: Column(
        children: [
          /// HEADER
          AppHeader(
            title: "Lesson",
            showBack: widget.showBack,
            showAddButton: true,
            addButtonText: "Add Lesson",
            onAdd: () {
              // Create lesson dialog
              Navigator.push(
                context,
                MaterialPageRoute(

                    builder: (_) =>
                        MultiBlocProvider(providers: [
                          BlocProvider(
                            create: (context) => InstructorTopicListBloc(),
                          ),

                          BlocProvider(
                            create: (_) => InstructorSubTopicListBloc(),
                          ),

                          BlocProvider(
                            create: (_) =>
                                InstructorStudentListBloc(),
                          ),

                          BlocProvider(
                            create: (_) =>
                                InstructorCreateLessonBloc(),
                          ),
                        ],
                            child: AddLessonScreen()
                        )
                ),
              );
            },
          ),

          /// LIST
          // Expanded(
          //   child: ListView.separated(
          //     padding: EdgeInsets.all(10),
          //     itemCount: lessons.length,
          //     separatorBuilder: (_, __) => SizedBox(height: 12),
          //     itemBuilder: (context, index) {
          //       return LessonCard(data: lessons[index]);
          //     },
          //   ),
          // ),

          Expanded(
            child: ListView.separated(

              controller: _scrollController,

              padding: EdgeInsets.all(10),

              itemCount: lessons.length + (hasMore ? 1 : 0),

              separatorBuilder: (_, __) => SizedBox(height: 12),

              itemBuilder: (context, index) {

                if(index == lessons.length) {

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return LessonCard(data: lessons[index]);
              },
            ),
          ),
        ],
      ),
    )
    );
  }

  // Future<void> fetchLessonList() async {
  //
  //   final prefs =
  //   await SharedPreferences.getInstance();
  //
  //   final userId =
  //   prefs.getString('user_id');
  //
  //   print("🔥 Instructor Id: $userId");
  //
  //   context.read<InstructorLessonListBloc>().add(
  //
  //     FetchInstructorLessonList(
  //
  //       instructorId:
  //       userId.toString(),
  //
  //       limit: "30",
  //
  //       offset: "0",
  //     ),
  //   );
  // }

  Future<void> fetchLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    offset = 0;
    hasMore = true;

    context.read<InstructorLessonListBloc>().add(

      FetchInstructorLessonList(

        instructorId: userId.toString(),

        limit: limit.toString(),

        offset: offset.toString(),
      ),
    );
  }

  Future<void> loadMoreLessons() async {

    if(isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    offset += 1;
    limit += 30;

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    context.read<InstructorLessonListBloc>().add(

      FetchInstructorLessonList(

        instructorId: userId.toString(),

        limit: limit.toString(),

        offset: offset.toString(),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final LessonData data;

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
                      data.name,
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
                          data.lessonDuration.toString(),
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
                              data.classDate,
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
                              //data.time.toString(),
                              data.lessonStart.toString(),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (_) => AddLessonScreen(
                              //   lesson: data,
                              // ),
                              builder: (_) => BlocProvider(

                                create: (_) =>
                                    InstructorTopicListBloc(),

                                child: AddLessonScreen(lesson: data),
                              ),
                            ),
                          );
                          // fetchLessonList();
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

                      GestureDetector(
                        onTap: (){
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

                  SizedBox(height: 10),

                  /// BUTTON
                  AppButton(
                    height: 34,
                    text: "Give rating",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonGiveRatingScreen(),
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
