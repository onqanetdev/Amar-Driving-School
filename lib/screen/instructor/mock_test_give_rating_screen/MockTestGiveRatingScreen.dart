import 'package:flutter/material.dart';

import '../../../helper/helper.dart';
import '../../../model/MockRatingItem.dart';
import '../../../model/MockRatingSection.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../rating_guide_screen/rating_guide_screen.dart';

class MockTestGiveRatingScreen extends StatefulWidget {
  const MockTestGiveRatingScreen({super.key});

  @override
  State<MockTestGiveRatingScreen> createState() =>
      _MockTestGiveRatingScreenState();
}

class _MockTestGiveRatingScreenState extends State<MockTestGiveRatingScreen> {
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
        6,
        (index) => MockRatingItem(title: "Vehicle approach"),
      ),
    ),
    MockRatingSection(
      title: "Lane Procedure:",
      items: [
        MockRatingItem(title: "Vehicle approach"),
        MockRatingItem(title: "Vehicle approach"),
      ],
    ),
  ];

  final percentList = [20,30, 50, 80, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ...sections.map((section) => sectionUI(section)),

                SizedBox(height: 20),

                /// SUBMIT
                AppButton(
                  text: "SUBMIT",
                  onTap: () {

                    final missing = getFirstUnratedItem();

                    if (missing != null) {
                      Helper.showToast(context, "Please rate");
                      return;
                    }

                    /// ✅ Generate JSON
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
          ),
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
            child: RatingGuideScreen(),
          ),
        );
      },
    );
  }

  Widget sectionUI(MockRatingSection section) {
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
            section.title,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "InterBold",
              color: Color(0xFF0B1F3A),
            ),
          ),

          SizedBox(height: 10),

          ...section.items.map((item) => ratingRow(item)).toList(),
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

  Map<String, dynamic> generateRatingJson() {
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

      String cleanTitle = section.title.replaceAll(":", "");

      result[cleanTitle] = sectionData;
    }

    return result;
  }

  String? getFirstUnratedItem() {
    for (var section in sections) {
      for (var item in section.items) {
        if (item.selectedRating == 0) {
          return "${section.title} → ${item.title}";
        }
      }
    }
    return null;
  }

}
