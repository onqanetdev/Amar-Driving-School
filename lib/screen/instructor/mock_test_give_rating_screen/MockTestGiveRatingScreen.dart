import 'package:amar_driving_school/bloc/instructor/mocktest_review/instructor_mocktest_review_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/mocktest_review/instructor_mocktest_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_event.dart';
import '../../../bloc/instructor/mocktest_review/instructor_mocktest_review_event.dart';
import '../../../helper/helper.dart';
import '../../../model/MockRatingItem.dart';
import '../../../model/MockRatingSection.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../rating_guide_screen/rating_guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockTestGiveRatingScreen extends StatefulWidget {
  final String mocktestTitle;
  final List<MockRatingItem> ids;
  //final String userId;
  final String studentUserId;
  final String topicId;
  const MockTestGiveRatingScreen({
    required this.mocktestTitle,super.key,
    required this.ids,
    //required this.userId,
    required this.studentUserId,
    required this.topicId
  });

  @override
  State<MockTestGiveRatingScreen> createState() =>
      _MockTestGiveRatingScreenState();
}

class _MockTestGiveRatingScreenState extends State<MockTestGiveRatingScreen> {


  final percentList = [20,30, 50, 80, 100];

  @override
  Widget build(BuildContext context) {

    return BlocListener<InstructorMocktestReviewBloc, InstructorMocktestReviewState>(

        listener: (context, state) {

          /// LOADING
          if(state is InstructorMocktestReviewLoading) {

            Helper.showToast(
              context,
              "Submitting review...",
            );
          }

          /// SUCCESS
          if(state is InstructorMocktestReviewSuccess) {

            Helper.showToast(

              context,

              state.reviewResponse.message,
            );

            Navigator.pop(context);
          }

          /// FAILURE
          if(state is InstructorMocktestReviewFailure) {

            Helper.showToast(
              context,
              state.error,
            );
          }
        },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 233, 233, 233),
        body: Column(
          children: [
            /// HEADER
            AppHeader(
              title: "Give Rating",
              showBack: true,
              showAddButton: true,
              addButtonText: "Rating Guide",
              addIcon: Icons.add,
              showAddIcon: false,
              onAdd: () {
                showRatingGuideDialog(context);
              },
            ),

            /// LIST
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                 // ...sections.map((section) => sectionUI(section)),
                  sectionUI(widget.mocktestTitle),
                 // ratingRow(widget.mocktestTitle),
                  SizedBox(height: 20),

                  /// SUBMIT
                  AppButton(
                    text: "SUBMIT",
                    onTap: () async {
                      print("The Sub Topic ids are ${widget.ids} ");
                      print("Student id is ${widget.studentUserId}");
                      /// VALIDATION
                      for (var item
                      in widget.ids) {
                        if(item.selectedRating == 0) {
                          Helper.showToast(
                            context,
                            "Please rate ${item.title}",
                          );
                          return;
                        }
                      }

                      /// CREATE RATINGS ARRAY
                      final ratingsData =

                      widget.ids.map((item) {

                        /// selectedRating = 1..5
                        /// convert into percentage

                        final percentage =

                        percentList[
                        item.selectedRating - 1
                        ];

                        return {

                          "subtopicid":
                          item.title,

                          "percentage":
                          percentage.toString(),
                        };

                      }).toList();

                      print("All My Submitted Rating Data are ⌚️${ratingsData}");

                      /// GET INSTRUCTOR ID
                      final prefs = await SharedPreferences.getInstance();

                      final instructorId =
                      prefs.getString('user_id');
                      /// Call Event
                      context.read<InstructorMocktestReviewBloc>()
                          .add(SubmitInstructorMocktestReview(

                        instructorId:
                        instructorId.toString(),

                        studentId:
                        widget.studentUserId,

                        topicId:
                        widget.topicId,

                        ratingsData:
                        ratingsData,
                      )
                      );
                    }, //onTap Ending

                    textStyle: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
  void showRatingGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
            ),
             child:  BlocProvider(

                create: (_) => InstructorAboutUsBloc()
                  ..add(FetchInstructorAboutUs(
                    pageTitle:
                    "Rating Guide for Mocktest",
                  ),
                  ),

                child: RatingGuideScreen(),
              )
            //child: RatingGuideScreen(),
          ),
        );
      },
    );
  }

  Widget sectionUI(String section) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            //section.title,
            section,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          SizedBox(height: 10),

          ...widget.ids.map((item) => ratingRow(item)).toList(),
        ],
      ),
    );
  }

  Widget ratingRow(MockRatingItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 FIRST LINE → TITLE
          Text(
            "${item.title}:",
            style: TextStyle(
              fontSize: 13,
              fontFamily: "InterMedium",
            ),
          ),

          SizedBox(height: 5),

          /// 🔹 SECOND LINE → BUTTONS + GRADE
          Row(
            children: [

              /// BUTTONS
              Expanded(
                child: Row(
                  children: List.generate(5, (index) {
                    final value = index + 1;
                    final isSelected = item.selectedRating == value;

                    return GestureDetector(
                      onTap: () {
                        print("The Sub Topic id is  ${item.title} ");
                        print("Tapped Percentage is ${percentList[index]}");
                        setState(() {
                          item.selectedRating = value;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        padding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color.fromARGB(255, 54, 113, 232)
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
                    );
                  }),
                ),
              ),

              SizedBox(width: 8),

              /// GRADE
              if (item.selectedRating != 0)
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 54, 113, 232),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  item.grade,
                  style: TextStyle(
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
}

