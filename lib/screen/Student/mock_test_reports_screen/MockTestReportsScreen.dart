import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/mocktest_review/student_mocktest_review_bloc.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_event.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_state.dart';
import '../../../model/MockRatingItem.dart';
import '../../../model/MockRatingSection.dart';
import '../../../model/student_all_model/student_mocktest_review_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MockTestReportsScreen extends StatefulWidget {
  const MockTestReportsScreen({super.key});

  @override
  State<MockTestReportsScreen> createState() =>
      _MockTestReportsScreenState();
}

class _MockTestReportsScreenState extends State<MockTestReportsScreen> {

  /// 🔥 EDIT MODE
  bool isEditMode = false;

  final percentList = [20, 30, 50, 80, 100];

  bool isMocktestReviewLoading = true;
  /// 🔹 DATA
  // List<MockRatingSection> sections = [
  //   MockRatingSection(
  //     title: "Pre-Drive Checks:",
  //     items: [
  //       MockRatingItem(title: "Vehicle approach"),
  //       MockRatingItem(title: "Start-up drill"),
  //     ],
  //   ),
  //   MockRatingSection(
  //     title: "Basic Control:",
  //     items: List.generate(
  //       4,
  //           (index) => MockRatingItem(title: "Vehicle approach"),
  //     ),
  //   ),
  // ];

  List<MocktestReviewData> sections = [

  ];

  @override
  void initState() {
    super.initState();
    fetchMocktestReviewList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [

      BlocListener<StudentMocktestReviewBloc, StudentMocktestReviewState>(

        listener: (context, state) {

          if(state is StudentMocktestReviewLoading) {

            setState(() {

              isMocktestReviewLoading = true;
            });
          }

          if(state is StudentMocktestReviewSuccess) {

            setState(() {

              isMocktestReviewLoading = false;

              sections =
                  state
                      .mocktestReviewResponse
                      .data;
            });

            print(
              "Mocktest Review Count => "
                  "${sections.length}",
            );
          }

          if(state is StudentMocktestReviewFailure) {

            setState(() {

              isMocktestReviewLoading = false;
            });

            print(state.error);
          }
        },
      ),

    ],
        child: Scaffold(
          backgroundColor: const Color(0xFFE9E9E9),

          body: Column(
            children: [

              /// 🔹 HEADER
              AppHeader(
                title: "Mock Test Report",
                showBack: true,
                showAddButton: false,
              ),

              /// 🔹 LIST
              Expanded(
                child:
                isMocktestReviewLoading

                    ? mocktestReviewShimmer()

                    : sections.isEmpty

                    ? emptyCard(
                  "No Mocktest Review Found!",
                ) :
                ListView(
                  padding: const EdgeInsets.all(10),
                  children: [

                    ...sections.map((section) => sectionUI(section)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        )
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

  /// 🔹 SECTION UI
  Widget sectionUI(MocktestReviewData section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            section.topicName ?? 'No name',
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          const SizedBox(height: 10),

          ...section.subtopics.map((item) => ratingRow(item)).toList(),
        ],
      ),
    );
  }

  /// 🔹 RATING ROW
  Widget ratingRow(MocktestReviewSubtopic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "${item.subtopicName}:",
            style: const TextStyle(
              fontSize: 13,
              fontFamily: "InterMedium",
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [

              /// 🔹 BUTTONS
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    final value = index + 1;
                   // final isSelected = item.selectedRating == value;
                    final isSelected = item.rating != "N/A" && item.rating == value.toString();
                    return GestureDetector(
                      //onTap: item.isEditable
                       //   ? () {
                        // setState(() {
                        //   item.selectedRating = value;
                        // });
                      //}
                        //  : null,

                      child: Opacity(
                        opacity: isSelected ? 1 : 0.6,
                        child: Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(
                                255, 54, 113, 232)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${percentList[index]}%",
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontFamily: "InterMedium",
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(width: 8),

              /// 🔹 GRADE (ALWAYS VISIBLE)
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 54, 113, 232),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${item.rating} %",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "InterBold",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 SUBMIT
  void onSubmit() {

  }

  Future<void> fetchMocktestReviewList() async {

    final prefs = await SharedPreferences.getInstance();

    final studentCode =
        prefs.getString("stud_user_id") ?? "";

    context.read<StudentMocktestReviewBloc>()
        .add(

      FetchStudentMocktestReview(

        studentCode: studentCode,
      ),
    );
  }

  Widget mocktestReviewShimmer() {

    return ListView.builder(

      padding: const EdgeInsets.all(16),

      itemCount: 2,

      itemBuilder: (_, index) {

        return Shimmer.fromColors(

          baseColor: Colors.grey.shade300,

          highlightColor: Colors.grey.shade100,

          child: Container(

            margin: const EdgeInsets.only(
              bottom: 20,
            ),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(24),
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// TOPIC TITLE
                Container(

                  height: 24,

                  width: 220,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 30),

                /// SUBTOPIC ROWS
                ...List.generate(3, (i) {

                  return Padding(

                    padding:
                    const EdgeInsets.only(
                      bottom: 30,
                    ),

                    child: Row(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              /// SUBTOPIC NAME
                              Container(

                                height: 18,

                                width: 150,

                                decoration:
                                BoxDecoration(

                                  color:
                                  Colors.white,

                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    4,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              /// PERCENTAGE BUTTONS
                              Row(

                                children:
                                List.generate(
                                  5,
                                      (index) {

                                    return Container(

                                      margin:
                                      const EdgeInsets
                                          .only(
                                        right: 8,
                                      ),

                                      height: 42,

                                      width: 55,

                                      decoration:
                                      BoxDecoration(

                                        color:
                                        Colors
                                            .white,

                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                          8,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        /// GRADE CIRCLE
                        Container(

                          height: 70,

                          width: 70,

                          decoration:
                          const BoxDecoration(

                            color: Colors.white,

                            shape:
                            BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

