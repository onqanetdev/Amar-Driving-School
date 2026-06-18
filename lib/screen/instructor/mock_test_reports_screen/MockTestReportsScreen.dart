import 'package:flutter/material.dart';

import '../../../bloc/student/mocktest_review/student_mocktest_review_bloc.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_event.dart';
import '../../../bloc/student/mocktest_review/student_mocktest_review_state.dart';
import '../../../model/MockRatingItem.dart';
import '../../../model/MockRatingSection.dart';
import '../../../model/student_all_model/student_mocktest_review_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MockTestReportsScreen extends StatefulWidget {

  final String? studentCode;
  const MockTestReportsScreen({super.key, this.studentCode});

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

    /// 🔥 DEFAULT VALUE (30%)
    // for (var section in sections) {
    //   for (var item in section.items) {
    //     item.selectedRating = 2; // 30%
    //     item.isEditable = false;
    //   }
    // }
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
                  state.mocktestReviewResponse.data;
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
            //addButtonText: isEditMode ? "Save" : "Edit",
            showAddIcon: false,
           // onAdd: toggleEditMode,
          ),

          /// 🔹 LIST
          Expanded(
            child: sections.isEmpty

                ? Center(
              child: Text(
                "No Mocktest Review Found!",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "InterBold",
                  color: Colors.grey,
                ),
              ),
            )

                : ListView(
              padding: const EdgeInsets.all(10),
              children: [

                ...sections.map((section) => sectionUI(section)),

                const SizedBox(height: 20),

                /// 🔹 SUBMIT
                // AppButton(
                //   text: "SUBMIT",
                //   onTap: onSubmit,
                //   textStyle: const TextStyle(
                //     fontFamily: "InterBold",
                //     fontSize: 12,
                //     color: Colors.white,
                //   ),
                // ),
                //
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    )
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
                    final List<String> overallRating = ["20", "30", "50", "80", "100"];
                    //final isSelected = item.selectedRating == value;
                    final isSelected = item.rating != "N/A" && item.rating == overallRating[index];
                    return GestureDetector(
                      // onTap: item.isEditable
                      //     ? () {
                      //   setState(() {
                      //     item.selectedRating = value;
                      //   });
                      // }
                      //     : null,

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
                   // "${item.rating} %"
                   //"H",
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

    //print();
  }

  Future<void> fetchMocktestReviewList() async {

    final prefs = await SharedPreferences.getInstance();

    final studentCode = widget.studentCode;

    print('Student Code ${studentCode}');

    context.read<StudentMocktestReviewBloc>()
        .add(FetchStudentMocktestReview(studentCode: studentCode!,
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
}