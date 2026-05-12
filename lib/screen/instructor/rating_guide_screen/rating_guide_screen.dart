import 'package:flutter/material.dart';

import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../model/RatingGuideModel.dart';

class RatingGuideScreen extends StatefulWidget {
  const RatingGuideScreen({super.key});

  @override
  State<RatingGuideScreen> createState() => _RatingGuideScreenState();
}

class _RatingGuideScreenState extends State<RatingGuideScreen> {
  @override
  Widget build(BuildContext context) {

    /// 🔥 DATA LIST
    final List<RatingGuideModel> guideList = [
      RatingGuideModel(
        title: "1: Driver is not able or not ready to perform a skill",
        description:
        "(not ready to progress to that skill or tried and was not able to continue)",
      ),
      RatingGuideModel(
        title:
        "2: Limited understanding and application of concepts and skills",
        description:
        "(not ready to progress to that skill or tried and was not able to continue)",
      ),
      RatingGuideModel(
        title:
        "3: Basic understanding and application of concepts and skills",
        description:
        "(performs the skill correctly but a little hesitant/unsure, may still need some help)",
      ),
      RatingGuideModel(
        title: "4: Good understanding and application of concept",
        description:
        "(performs the skill correctly and confidently on a consistent basis with little help)",
      ),
      RatingGuideModel(
        title:
        "5: Very good understanding and application of concepts and skills",
        description:
        "(not ready to progress to that skill or tried and was not able to continue)",
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Marking Scale Definitions:",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "InterBold",
                      color: HexColor("${AppColor.colorOfEditColour}"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey),
                )
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 LIST
            ...List.generate(guideList.length, (index) {
              final item = guideList[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ITEM
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// TITLE
                        Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: "InterBold",
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 3),

                        /// DESCRIPTION
                        Text(
                          item.description,
                          style: TextStyle(
                            fontFamily: "InterRegular",
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// DIVIDER (except last)
                  if (index != guideList.length - 1)
                    Divider(
                      color: Colors.grey.withOpacity(0.4),
                      thickness: 1,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}