import 'package:flutter/material.dart';

import '../../../model/RatingItem.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';

class LessonReportScreen extends StatefulWidget {
  const LessonReportScreen({super.key});

  @override
  State<LessonReportScreen> createState() => _LessonReportScreenState();
}

class _LessonReportScreenState extends State<LessonReportScreen> {

  /// 🔥 EDIT MODE
  bool isEditMode = false;

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
  void initState() {
    super.initState();

    /// 🔥 DEFAULT VALUE (optional)
    for (var section in sections) {
      for (var item in section.items) {
        item.selected = 2; // default selection
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(
        children: [

          /// 🔹 HEADER
          AppHeader(
            title: "Lesson Report",
            showBack: true,
            showAddButton: true,
            addButtonText: isEditMode ? "Save" : "Edit",
            showAddIcon: false,
            onAdd: toggleEditMode,
          ),

          /// 🔹 LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [

                ...sections.map((section) => ratingSection(section)),

                const SizedBox(height: 20),

                /// 🔹 SUBMIT
                AppButton(
                  text: "SUBMIT",
                  onTap: onSubmit,
                  textStyle: const TextStyle(
                    fontFamily: "InterBold",
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 TOGGLE EDIT
  void toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  /// 🔹 SECTION UI
  Widget ratingSection(RatingSection section) {
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
            section.title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          const SizedBox(height: 10),

          ...section.items.map((item) => ratingRow(item)).toList(),
        ],
      ),
    );
  }

  /// 🔹 RATING ROW
  Widget ratingRow(RatingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          /// TITLE
          Expanded(
            child: Text(
              "${item.title}:",
              style: const TextStyle(
                fontSize: 13,
                fontFamily: "InterMedium",
                color: Colors.black87,
              ),
            ),
          ),

          /// OPTIONS
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final isSelected = item.selected == value;

              return GestureDetector(
                onTap: isEditMode
                    ? () {
                  setState(() {
                    item.selected = value;
                  });
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
    final json = generateJson();
    print(json);
  }

  /// 🔹 JSON
  Map<String, dynamic> generateJson() {
    Map<String, dynamic> result = {};

    for (var section in sections) {
      Map<String, dynamic> sectionData = {};

      for (var item in section.items) {
        sectionData[item.title] = item.selected;
      }

      result[section.title.replaceAll(":", "")] = sectionData;
    }

    return result;
  }
}