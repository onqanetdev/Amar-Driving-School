import 'package:amar_driving_school/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_event.dart';
import '../../../bloc/instructor/lesson_review/instructor_lesson_review_bloc.dart';
import '../../../bloc/instructor/lesson_review/instructor_lesson_review_event.dart';
import '../../../bloc/instructor/lesson_review/instructor_lesson_review_state.dart';
import '../../../model/RatingItem.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../rating_guide_screen/rating_guide_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonGiveRatingScreen extends StatefulWidget {
  final String subjectName;
  final List<RatingItem> subTopics;
  final String studentUserId;
  final String topicId;
  const LessonGiveRatingScreen({super.key, required this.subjectName, required this.subTopics, required this.studentUserId, required this.topicId});

  @override
  State<LessonGiveRatingScreen> createState() => _LessonGiveRatingScreenState();
}

class _LessonGiveRatingScreenState extends State<LessonGiveRatingScreen> {



  @override
  Widget build(BuildContext context) {
    return
      BlocListener<InstructorLessonReviewBloc, InstructorLessonReviewState>(

          listener: (context, state) {

          /// LOADING
          if(state is InstructorLessonReviewLoading) {

            Helper.showToast(
              context,
              "Submitting review...",
            );
          }

          /// SUCCESS
          if(state is InstructorLessonReviewSuccess) {

            Helper.showToast(

              context,

              state.reviewResponse.message,
            );

            Navigator.pop(context);
          }

          /// FAILURE
          if(state is InstructorLessonReviewFailure) {

            Helper.showToast(
              context,
              state.error,
            );
          }
        },

      child: Scaffold(
      backgroundColor: Color(0xFFE9E9E9),

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

                //...sections.map((section) => ratingSection(section)),
                ratingSection(widget.subjectName),
                SizedBox(height: 20),

                /// SUBMIT BUTTON
                AppButton(
                  text: "SUBMIT",
                  onTap: () async {

                    /// VALIDATION
                    for (var item
                    in widget.subTopics) {

                      if(item.selected == 0) {

                        Helper.showToast(

                          context,

                          "Please rate ${item.title}",
                        );

                        return;
                      }
                    }

                    /// CREATE RATINGS ARRAY
                    final ratingsData =

                    widget.subTopics.map((item) {

                      return {

                        "subtopicid":
                        item.title,

                        "rating":
                        item.selected.toString(),
                      };

                    }).toList();

                    print(ratingsData);

                    /// GET INSTRUCTOR ID
                    final prefs = await SharedPreferences.getInstance();

                    final instructorId =
                    prefs.getString('user_id');

                    /// CALL EVENT
                    context.read<InstructorLessonReviewBloc>()
                        .add(SubmitInstructorLessonReview(

                        instructorId:
                        instructorId.toString(),

                        studentId:
                        widget.studentUserId,

                        topicId:
                        widget.topicId,

                        ratingsData:
                        ratingsData,
                      ),
                    );
                  } ,//On tap ending
                  textStyle: TextStyle(
                    fontFamily: "InterBold",
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }

  Widget ratingSection(String section) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            section,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          SizedBox(height: 10),

          /// ITEMS
          ...widget.subTopics.map((item) => ratingRow(item)).toList(),
        ],
      ),
    );
  }

  Widget ratingRow(RatingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          /// TITLE
          Expanded(
            child: Text(
              "${item.title}:",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "InterMedium",
                color: Colors.black87,
              ),
            ),
          ),

          /// OPTIONS 1–5
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = item.selected == value;

              return GestureDetector(
                onTap: () {
                  print('Value is ${value}, for the item ${item.title}');
                  setState(() {
                   item.selected = value;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Color.fromARGB(255, 54, 113, 232) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "$value",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontFamily: "InterMedium",
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }



  void showRatingGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10), // 🔥 more width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75, // 🔥 control height
            ),
            child:
            BlocProvider(

              create: (_) => InstructorAboutUsBloc()
                ..add(FetchInstructorAboutUs(
                  pageTitle:
                  "Rating Guide for Lesson",
                ),
                ),

              child: RatingGuideScreen(),
            ),
          ),
        );
      },
    );
  }
}