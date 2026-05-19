import 'package:amar_driving_school/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_event.dart';
import '../../../model/RatingItem.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../rating_guide_screen/rating_guide_screen.dart';

class LessonGiveRatingScreen extends StatefulWidget {
  const LessonGiveRatingScreen({super.key});

  @override
  State<LessonGiveRatingScreen> createState() => _LessonGiveRatingScreenState();
}

class _LessonGiveRatingScreenState extends State<LessonGiveRatingScreen> {

  List<RatingSection> sections = [

    RatingSection(
      title: "Pre-Drive Checks:",
      items: [
        RatingItem(title: "Vehicle approach"),
        RatingItem(title: "Start-up drill"),
      ],
    ),

    RatingSection(
      title: "Basic Control:",
      items: [
        RatingItem(title: "Braking, stopping"),
        RatingItem(title: "Accelerating, coasting"),
        RatingItem(title: "Steering, turning"),
        RatingItem(title: "Yielding"),
        RatingItem(title: "Search, Evaluate, Execute (SEE)"),
        RatingItem(title: "Curve negotiation"),
        RatingItem(title: "Right-of-way execution"),
      ],
    ),

    RatingSection(
      title: "Lane Procedure:",
      items: [
        RatingItem(title: "Lane positioning"),
        RatingItem(title: "Lane changing"),
        RatingItem(title: "Parked vehicle negotiation"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                ...sections.map((section) => ratingSection(section)),

                SizedBox(height: 20),

                /// SUBMIT BUTTON
                AppButton(
                  text: "SUBMIT",
                  onTap: () {

                    final missing = getFirstUnratedItem();

                    if (missing != null) {

                      Helper.showToast(context, "Please rate: $missing");
                      return;
                    }
                    final jsonData = generateRatingJson();

                    print(jsonData);
                  },
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
    );
  }

  Widget ratingSection(RatingSection section) {
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
            section.title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          SizedBox(height: 10),

          /// ITEMS
          ...section.items.map((item) => ratingRow(item)).toList(),
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
                    color: isSelected
                        ? Color.fromARGB(255, 54, 113, 232)
                        : Colors.grey.shade300,
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

  Map<String, dynamic> generateRatingJson() {
    Map<String, dynamic> result = {};

    for (var section in sections) {
      Map<String, dynamic> sectionData = {};

      for (var item in section.items) {
        sectionData[item.title] = item.selected;
      }

      /// remove ":" from title
      String cleanTitle = section.title.replaceAll(":", "");

      result[cleanTitle] = sectionData;
    }

    return result;
  }

  String? getFirstUnratedItem() {
    for (var section in sections) {
      for (var item in section.items) {
        if (item.selected == 0) {
          return "${section.title} → ${item.title}";
        }
      }
    }
    return null;
  }

  bool validateRatings() {
    for (var section in sections) {
      for (var item in section.items) {
        if (item.selected == 0) {
          return false; // not rated
        }
      }
    }
    return true; // ✅ all rated
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