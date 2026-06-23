import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/mocktest_real_review_list/student_real_mocktest_review_bloc.dart';
import '../../../bloc/student/mocktest_real_review_list/student_real_mocktest_review_event.dart';
import '../../../bloc/student/mocktest_real_review_list/student_real_mocktest_review_state.dart';
import '../../../model/student_all_model/student_real_mocktest_review_list_model.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MockTestReportsScreen extends StatefulWidget {
  final String? topicId;
  const  MockTestReportsScreen({this.topicId,super.key});

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

      BlocListener<StudentRealMocktestReviewBloc, StudentRealMocktestReviewState>(

        listener: (context, state) {

          if(state is StudentRealMocktestReviewLoading) {

            setState(() {

              isMocktestReviewLoading = true;
            });
          }

          if(state is StudentRealMocktestReviewSuccess) {

            setState(() {

              isMocktestReviewLoading = false;

              sections = state.mocktestReviewResponse.data;
            });

            print(
              "Mocktest Review Count => "
                  "${sections.length}",
            );
          }

          if(state is StudentRealMocktestReviewFailure) {

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

                    ? _mocktestShimmer()

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
                    final isSelected =
                        (int.tryParse(item.rating ?? "0") ?? 0)
                            == percentList[index];
                    final value = index + 1;
                   // final isSelected = item.selectedRating == value;
                    //final isSelected = item.rating != "N/A" && item.rating == value.toString();
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
                  getGrade(item.rating),
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

    context.read<StudentRealMocktestReviewBloc>().add(FetchStudentRealMocktestReview(
        studentCode: studentCode,
       topicId: widget.topicId!,
      ),
    );
  }

  String getGrade(String? rating) {
    switch (rating) {
      case "20":
        return "E";
      case "30":
        return "D";
      case "50":
        return "C";
      case "80":
        return "B";
      case "100":
        return "A";
      default:
        return "-"; // For N/A, null, or unexpected values
    }
  }

  // Widget mocktestReviewShimmer() {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(10),
  //     itemCount: 3,
  //     itemBuilder: (_, index) {
  //       return Shimmer.fromColors(
  //         baseColor: Colors.grey.shade300,
  //         highlightColor: Colors.grey.shade100,
  //         child: Container(
  //           margin: const EdgeInsets.only(bottom: 12),
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //
  //               /// TOPIC TITLE
  //               Container(
  //                 height: 20,
  //                 width: 180,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(6),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 12),
  //
  //               /// SUBTOPICS
  //               ...List.generate(3, (rowIndex) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(bottom: 14),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //
  //                       /// SUBTOPIC NAME
  //                       Container(
  //                         height: 14,
  //                         width: 140,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(4),
  //                         ),
  //                       ),
  //
  //                       const SizedBox(height: 8),
  //
  //                       /// BUTTONS + GRADE
  //                       Row(
  //                         children: [
  //
  //                           Expanded(
  //                             child: Row(
  //                               children: List.generate(5, (i) {
  //                                 return Container(
  //                                   margin: const EdgeInsets.only(right: 6),
  //                                   height: 28,
  //                                   width: 42,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius:
  //                                     BorderRadius.circular(6),
  //                                   ),
  //                                 );
  //                               }),
  //                             ),
  //                           ),
  //
  //                           const SizedBox(width: 8),
  //
  //                           /// GRADE CIRCLE
  //                           Container(
  //                             width: 32,
  //                             height: 32,
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               shape: BoxShape.circle,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               }),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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

