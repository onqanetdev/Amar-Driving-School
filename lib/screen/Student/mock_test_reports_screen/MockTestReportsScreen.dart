import 'package:flutter/material.dart';

import '../../../model/MockRatingItem.dart';
import '../../../model/MockRatingSection.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';

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

  /// 🔹 DATA
  List<MockRatingSection> sections = [
    MockRatingSection(
      title: "Pre-Drive Checks:",
      items: [
        MockRatingItem(title: "Vehicle approach"),
        MockRatingItem(title: "Start-up drill"),
      ],
    ),
    MockRatingSection(
      title: "Basic Control:",
      items: List.generate(
        4,
            (index) => MockRatingItem(title: "Vehicle approach"),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();

    /// 🔥 DEFAULT VALUE (30%)
    for (var section in sections) {
      for (var item in section.items) {
        item.selectedRating = 2; // 30%
        item.isEditable = false;
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
            title: "Mock Test Report",
            showBack: true,
            showAddButton: false,
          ),

          /// 🔹 LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [

                ...sections.map((section) => sectionUI(section)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 SECTION UI
  Widget sectionUI(MockRatingSection section) {
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
  Widget ratingRow(MockRatingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(
            "${item.title}:",
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
                    final isSelected = item.selectedRating == value;

                    return GestureDetector(
                      onTap: item.isEditable
                          ? () {
                        setState(() {
                          item.selectedRating = value;
                        });
                      }
                          : null,

                      child: Opacity(
                        opacity: item.isEditable ? 1 : 0.6,
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
                  item.grade,
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
    final json = generateJson();
    print(json);
  }

  /// 🔹 JSON
  Map<String, dynamic> generateJson() {
    Map<String, dynamic> result = {};

    for (var section in sections) {
      Map<String, dynamic> sectionData = {};

      for (var item in section.items) {
        sectionData[item.title] = {
          "rating": item.selectedRating,
          "percentage": item.percentage,
          "grade": item.grade,
        };
      }

      result[section.title.replaceAll(":", "")] = sectionData;
    }

    return result;
  }
}