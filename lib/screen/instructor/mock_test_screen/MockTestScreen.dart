import 'package:amar_driving_school/bloc/instructor/create_mocktest/instructor_create_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_edit/instructor_update_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_list_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_list_event.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_state.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_review/instructor_mocktest_review_bloc.dart';
import 'package:amar_driving_school/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/lesson_list/instructor_lesson_list_state.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_bloc.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_event.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_state.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/LessonModel.dart';
import '../../../model/MockRatingItem.dart';
import '../../../model/instructor_create_mocktest/instructor_mocktest_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../add_mock_test_screen/AddMockTestScreen.dart';
import '../mock_test_give_rating_screen/MockTestGiveRatingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockTestScreen extends StatefulWidget {
  final bool showBack;
  MockTestScreen({super.key,this.showBack = false});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  final List<MocktestData> allMocktests = [

  ];

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
  Widget build(BuildContext context) {
    //bloc and state parameter
    return MultiBlocListener(

        listeners: [

          /// MOCKTEST LIST
          BlocListener<
              InstructorMocktestListBloc,
              InstructorMocktestListState>(

            listener: (context, state) {

              /// LOADING
              if(state
              is InstructorMocktestListLoading
                  && offset == 0) {

                LoaderHelper.show(context);
              }

              /// SUCCESS
              if(state
              is InstructorMocktestListSuccess) {

                LoaderHelper.hide(context);

                setState(() {

                  if(offset == 0) {

                    allMocktests.clear();
                  }

                  allMocktests.addAll(

                    state
                        .mocktestListResponse
                        .data,
                  );

                  isLoadingMore = false;

                  if(state
                      .mocktestListResponse
                      .data
                      .length < limit) {

                    hasMore = false;
                  }
                });
              }

              /// FAILURE
              if(state
              is InstructorMocktestListFailure) {

                LoaderHelper.hide(context);

                Helper.showToast(
                  context,
                  state.error,
                );
              }
            },
          ),

          /// DELETE MOCKTEST
          BlocListener<InstructorMocktestDeleteBloc, InstructorMocktestDeleteState>(

            listener: (context, state) {

              /// LOADING
              if(state is InstructorMocktestDeleteLoading) {

                LoaderHelper.show(context);
              }

              /// SUCCESS
              if(state is InstructorMocktestDeleteSuccess) {

                LoaderHelper.hide(context);

                Helper.showToast(

                  context,

                  state.deleteResponse.message,
                );

                /// REFRESH LIST
                //fetchLessonList();
              }

              /// FAILURE
              if(state
              is InstructorMocktestDeleteFailure) {

                LoaderHelper.hide(context);

                Helper.showToast(
                  context,
                  state.error,
                );
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
                     showAddButton: true,
                     addButtonText: "Add Mocktest",
                     onAdd: () async {
                       // Create lesson dialog
                       // Navigator.push(
                       //   context,
                       //   MaterialPageRoute(
                       //   //  builder: (_) => AddMockTestScreen(),
                       //     builder: (_) => MultiBlocProvider(
                       //
                       //       providers: [
                       //
                       //         BlocProvider(
                       //           create: (_) =>
                       //               InstructorTopicListBloc(),
                       //         ),
                       //
                       //         BlocProvider(
                       //           create: (_) =>
                       //               InstructorSubTopicListBloc(),
                       //         ),
                       //
                       //         BlocProvider(
                       //           create: (_) =>
                       //               InstructorStudentListBloc(),
                       //         ),
                       //
                       //         BlocProvider(
                       //           create: (_) =>
                       //               InstructorCreateMocktestBloc(),
                       //         ),
                       //         // Mocktest Edit
                       //         BlocProvider(
                       //           create: (_) =>
                       //               InstructorUpdateMocktestBloc(),
                       //         ),
                       //       ],
                       //
                       //       child: AddMockTestScreen(),
                       //     ),
                       //   ),
                       // );
                       final result = await Navigator.push(context,
                           MaterialPageRoute(
                             //  builder: (_) => AddMockTestScreen(),
                             builder: (_) => MultiBlocProvider(

                               providers: [

                                 BlocProvider(
                                   create: (_) =>
                                       InstructorTopicListBloc(),
                                 ),

                                 BlocProvider(
                                   create: (_) =>
                                       InstructorSubTopicListBloc(),
                                 ),

                                 BlocProvider(
                                   create: (_) =>
                                       InstructorStudentListBloc(),
                                 ),

                                 BlocProvider(
                                   create: (_) =>
                                       InstructorCreateMocktestBloc(),
                                 ),
                                 // Mocktest Edit
                                 BlocProvider(
                                   create: (_) =>
                                       InstructorUpdateMocktestBloc(),
                                 ),
                               ],

                               child: AddMockTestScreen(),
                             ),
                           ),
                       );
                       if (result == true) {
                         fetchLessonList();
                       }
                     },
                   ),

                   /// LIST
                   Expanded(
                     child: ListView.separated(
                       controller: _scrollController,
                       padding: EdgeInsets.all(10),
                       itemCount: hasMore ? allMocktests.length + 1 : allMocktests.length,
                       separatorBuilder: (_, __) => SizedBox(height: 12),
                       itemBuilder: (context, index) {
                         if(index == allMocktests.length) {

                           return const Padding(

                             padding: EdgeInsets.all(16),

                             child: Center(
                               child:
                               CircularProgressIndicator(),
                             ),
                           );
                         }

                         return LessonCard(data: allMocktests[index]);
                       },
                     ),
                   ),
                 ],
               ),
             ),
    );

  }



  Future<void> fetchLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    offset = 0;
    hasMore = true;


    //bloc
    context.read<InstructorMocktestListBloc>().add(

      FetchInstructorMocktestList(

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

    //bloc
    context.read<InstructorMocktestListBloc>().add(

      FetchInstructorMocktestList(

        instructorId: userId.toString(),

        limit: limit.toString(),

        offset: offset.toString(),
      ),
    );
  }

}

class LessonCard extends StatelessWidget {
  final MocktestData data;

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
                        onTap: () async {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //
                          //     builder: (_) => MultiBlocProvider(
                          //
                          //       providers: [
                          //
                          //         BlocProvider(
                          //           create: (_) =>
                          //               InstructorTopicListBloc(),
                          //         ),
                          //
                          //         BlocProvider(
                          //           create: (_) =>
                          //               InstructorSubTopicListBloc(),
                          //         ),
                          //
                          //         BlocProvider(
                          //           create: (_) =>
                          //               InstructorStudentListBloc(),
                          //         ),
                          //
                          //         BlocProvider(
                          //           create: (_) =>
                          //               InstructorCreateMocktestBloc(),
                          //         ),
                          //
                          //         BlocProvider(
                          //           create: (_) =>
                          //               InstructorUpdateMocktestBloc(),
                          //         ),
                          //
                          //       ],
                          //
                          //       child: AddMockTestScreen(mocktest: data,),
                          //     ),
                          //   ),
                          //
                          // );

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [

                                  BlocProvider(
                                    create: (_) =>
                                        InstructorTopicListBloc(),
                                  ),

                                  BlocProvider(
                                    create: (_) =>
                                        InstructorSubTopicListBloc(),
                                  ),

                                  BlocProvider(
                                    create: (_) =>
                                        InstructorStudentListBloc(),
                                  ),

                                  BlocProvider(
                                    create: (_) =>
                                        InstructorCreateMocktestBloc(),
                                  ),

                                  BlocProvider(
                                    create: (_) =>
                                        InstructorUpdateMocktestBloc(),
                                  ),

                                ],
                                child: AddMockTestScreen(
                                  mocktest: data,
                                ),
                              ),
                            ),
                          );

                          if (result == true) {
                            context.read<InstructorMocktestListBloc>().add(
                              FetchInstructorMocktestList(
                                instructorId: data.instructorId,
                                limit: '10',
                                offset: "0",
                              ),
                            );
                          }
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
                  if (data.rating != null)
                  AppButton(
                    height: 34,
                    text: "Give rating",
                    gradientColors: [
                      Colors.grey,
                      Colors.grey,
                    ],
                    onTap: () {

                    },
                    textStyle: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                  else
                    AppButton(
                      height: 34,
                      text: "Give rating",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(providers: [
                              BlocProvider(
                                create: (_) => InstructorMocktestReviewBloc(),
                              ),
                            ],
                              child:
                              MockTestGiveRatingScreen(mocktestTitle: data.name, ids: data.subtopicId
                                  .split(',')
                                  .map((e) => MockRatingItem(
                                title: e,
                              ),
                              ).toList(),
                                studentUserId: data.userId,
                                topicId: data.topicId,),
                            ),
                          ),
                        );

                      },
                      textStyle: TextStyle(
                        fontFamily: "InterBold",
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )
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
                    print(data.id);
                    context.read<InstructorMocktestDeleteBloc>().add(DeleteInstructorMocktest(
                        mockId:
                        data.id,
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
