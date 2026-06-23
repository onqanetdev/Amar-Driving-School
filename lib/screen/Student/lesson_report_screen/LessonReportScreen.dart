import 'package:amar_driving_school/bloc/student/real_review_list/student_real_lesson_review_bloc.dart';
import 'package:amar_driving_school/bloc/student/real_review_list/student_real_lesson_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/lesson_review/student_lesson_review_bloc.dart';
import '../../../bloc/student/lesson_review/student_lesson_review_event.dart';
import '../../../bloc/student/lesson_review/student_lesson_review_state.dart';
import '../../../bloc/student/real_review_list/student_real_lesson_review_event.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/RatingItem.dart';
//import '../../../model/student_all_model/student_lesson_review.dart';
import '../../../model/student_all_model/student_real_lesson_review_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class LessonReportScreen extends StatefulWidget {

  final String? lessonTopic;
  const LessonReportScreen({super.key, this.lessonTopic});

  @override
  State<LessonReportScreen> createState() => _LessonReportScreenState();
}

class _LessonReportScreenState extends State<LessonReportScreen> {

  /// 🔥 EDIT MODE
  bool isEditMode = false;

  bool isLoading = true;

  List<LessonReviewData> sections = [];


  @override
  void initState() {
    super.initState();

    /// 🔥 DEFAULT VALUE (optional)
    // for (var section in sections) {
    //   for (var item in section.subtopics) {
    //
    //     //item.selected = 2; // default selection
    //
    //   }
    // }

    fetchLessonReview();
  }

  @override
  Widget build(BuildContext context) {

    return  MultiBlocListener(

        listeners: [

          /// LESSON REVIEW LISTENER
          BlocListener<StudentRealLessonReviewBloc, StudentRealLessonReviewState>(

            listener: (context, state) {

              /// LOADING
              if(state is StudentRealLessonReviewLoading) {
                //LoaderHelper.show(context);
                setState(() {
                  isLoading = true;
                });

              }

              /// SUCCESS
              if(state is StudentRealLessonReviewSuccess) {

                // LoaderHelper.hide(context);
                //
                // setState(() {
                //
                //   sections = state.lessonReviewResponse.data;
                // });

                setState(() {
                  isLoading = false;
                  sections = state.lessonReviewResponse.data;
                });

                print("Sections List ${sections}");
              }

              /// FAILURE
              if(state is StudentLessonReviewFailure) {

                //print("The Failure");

                //LoaderHelper.hide(context);

                setState(() {
                  isLoading = false;
                });
                //print(state.error);
              }
            },
          ),
        ],


        child:  Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(
        children: [

          /// 🔹 HEADER
          AppHeader(
            title: "Lesson Report",
            showBack: true,
            showAddButton: false,
          ),

          /// 🔹 LIST
          Expanded(
            child: isLoading
                ? _mocktestShimmer()
                : ListView(
              padding: const EdgeInsets.all(10),
              children: [

                ...sections.map((section) => ratingSection(section)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }

  /// 🔥 TOGGLE EDIT
  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  /// 🔹 SECTION UI
  Widget ratingSection(LessonReviewData section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            section.topicName ?? " ",
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
  Widget ratingRow(LessonReviewSubtopic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      /// Changing this Row to Column

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "${item.subtopicName}:",
            style: const TextStyle(
              fontSize: 13,
              fontFamily: "InterMedium",
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 10,),

          /// OPTIONS
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              //final isSelected = Int(item.rating) == value;
              final isSelected = item.rating != "N/A" && item.rating == value.toString();
              return GestureDetector(
                onTap: isEditMode
                    ? () {
                  // setState(() {
                  //   item.selected = value;
                  // });
                }
                    : null,

                child: Opacity(
                  opacity: isEditMode ? 1 : 0.6,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(255, 54, 113, 232)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "$value",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.black54,
                        fontFamily: "InterMedium",
                      ),
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

  /// 🔹 SUBMIT
  void onSubmit() {
    // final json = generateJson();
    //print(json);
  }

  Future<void> fetchLessonReview() async {

    final prefs = await SharedPreferences.getInstance();

    final studentCode = prefs.getString("stud_user_id") ?? "";

    print('My Student Code is ${studentCode}');
    print('My Lesson Topic id is ${widget.lessonTopic!}');

    // context.read<StudentLessonReviewBloc>().add(
    //   FetchStudentLessonReview(
    //     studentCode: studentCode,
    //   ),
    // );

    context.read<StudentRealLessonReviewBloc>().add(
      FetchStudentRealLessonReview(
        studentCode: studentCode, topicId: widget.lessonTopic!,
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

}