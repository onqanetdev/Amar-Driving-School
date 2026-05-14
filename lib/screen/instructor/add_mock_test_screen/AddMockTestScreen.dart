import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:flutter/material.dart';

import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../model/CategoryModel.dart';
import '../../../model/LessonModel.dart';
import '../../../model/SubCategoryModel.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';

class AddMockTestScreen extends StatefulWidget {
  final LessonModel? lesson;
  const AddMockTestScreen({super.key,this.lesson});

  @override
  State<AddMockTestScreen> createState() => _AddMockTestScreenState();
}

class _AddMockTestScreenState extends State<AddMockTestScreen> {

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final hourController = TextEditingController();
  final minController = TextEditingController();

  CategoryModel? selectedCategory;
  List<CategoryModel> selectedCategories = [];

  List<CategoryModel> allCategories = [
    CategoryModel(
      name: "Pre-Drive Checks",
      subCategories: [
        SubCategoryModel(name: "Vehicle approach"),
        SubCategoryModel(name: "Start-up drill"),
        SubCategoryModel(name: "Vehicle approachsssss"),
        SubCategoryModel(name: "Start-up drillssss"),
      ],
    ),
    CategoryModel(
      name: "Basic Control",
      subCategories: [
        SubCategoryModel(name: "Braking"),
        SubCategoryModel(name: "Steering"),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.lesson != null) {
      /// 👉 EDIT MODE
      titleController.text = widget.lesson!.name;
      dateController.text = widget.lesson!.date;
      timeController.text = widget.lesson!.time!;
      hourController.text = widget.lesson!.duration!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(
        children: [

          /// HEADER
          AppHeader(
            title: "Create Mock Test",
            showBack: true,
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      /// 🔹 TITLE
                      AppInputField(
                        controller: titleController,
                        hintText: "Advance Car Drive",
                        fillColor: AppColor.colorInputBg,
                        borderColor: AppColor.colorInputBorder,
                        focusedBorderColor: AppColor.colorInputFocusBorder,
                        hintColor: AppColor.colorInputHint,
                        borderRadius: 10,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 10),

                      /// 🔹 DATE + TIME
                      Row(
                        children: [

                          Expanded(
                            child: AppInputField(
                              controller: dateController,
                              hintText: "Start Date",
                              fillColor: AppColor.colorInputBg,
                              borderColor: AppColor.colorInputBorder,
                              focusedBorderColor:
                              AppColor.colorInputFocusBorder,
                              hintColor: AppColor.colorInputHint,
                              borderRadius: 10,
                              obscureText: false,
                              readOnly: true,
                              onTap: pickDate,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: AppInputField(
                              controller: timeController,
                              hintText: "Start Time",
                              fillColor: AppColor.colorInputBg,
                              borderColor: AppColor.colorInputBorder,
                              focusedBorderColor:
                              AppColor.colorInputFocusBorder,
                              hintColor: AppColor.colorInputHint,
                              borderRadius: 10,
                              obscureText: false,
                              readOnly: true,
                              onTap: pickTime,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 🔹 DURATION
                      Row(
                        children: [

                          const Text(
                            "Duration:",
                            style: TextStyle(fontFamily: "InterMedium"),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: AppInputField(
                              controller: hourController,
                              hintText: "1hr",
                              fillColor: AppColor.colorInputBg,
                              borderColor: AppColor.colorInputBorder,
                              focusedBorderColor:
                              AppColor.colorInputFocusBorder,
                              hintColor: AppColor.colorInputHint,
                              borderRadius: 10,
                              obscureText: false,
                            ),
                          ),

                          const SizedBox(width: 6),
                          const Text(":"),
                          const SizedBox(width: 6),

                          Expanded(
                            child: AppInputField(
                              controller: minController,
                              hintText: "30Min",
                              fillColor: AppColor.colorInputBg,
                              borderColor: AppColor.colorInputBorder,
                              focusedBorderColor:
                              AppColor.colorInputFocusBorder,
                              hintColor: AppColor.colorInputHint,
                              borderRadius: 10,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Divider(),

                      const SizedBox(height: 10),

                      /// 🔹 CATEGORY + ADD
                      Row(
                        children: [

                          Expanded(child: dropdownBox()),

                          const SizedBox(width: 10),

                          AppButtonAnimation(
                            onTap: addCategory,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 54, 113, 232),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 🔥 SELECTED CATEGORY
                      /// 🔥 SELECTED CATEGORY (PRO UI)
                      ...selectedCategories.map((cat) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔹 CATEGORY HEADER
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      cat.name,
                                      style: TextStyle(
                                        fontFamily: "InterBold",
                                        fontSize: 14,
                                        color: Color(0xFF002248),
                                      ),
                                    ),
                                  ),

                                  /// ❌ REMOVE BUTTON
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategories.remove(cat);
                                      });
                                    },
                                    child: Icon(Icons.close, size: 18, color: Colors.red),
                                  )
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// 🔹 SUBCATEGORY CHIPS
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// 🔹 TITLE
                                  Text(
                                    "Sub Categories",
                                    style: TextStyle(
                                      fontFamily: "InterBold",
                                      fontSize: 13,
                                      color: Color(0xFF002248),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  ...List.generate(cat.subCategories.length, (index) {
                                    final sub = cat.subCategories[index];
                                    final isSelected = sub.isSelected;

                                    return GestureDetector(
                                      onTap: () {

                                        setState(() {
                                          sub.isSelected = !sub.isSelected;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 6),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color.fromARGB(255, 54, 113, 232).withOpacity(0.1)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color.fromARGB(255, 54, 113, 232)
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          children: [

                                            /// 🔹 NUMBER
                                            Text(
                                              "${index + 1}.",
                                              style: TextStyle(
                                                fontFamily: "InterBold",
                                                color: isSelected
                                                    ? const Color.fromARGB(255, 54, 113, 232)
                                                    : Colors.black,
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            /// 🔹 NAME
                                            Expanded(
                                              child: Text(
                                                sub.name,
                                                style: TextStyle(
                                                  fontFamily: "InterMedium",
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),

                                            /// 🔹 CHECK ICON (optional)
                                            if (isSelected)
                                              Icon(Icons.check_circle,
                                                  color: Color.fromARGB(255, 54, 113, 232), size: 18),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      /// SUBMIT
                      AppButton(
                        text: "SUBMIT",
                        onTap: onSubmit,
                        textStyle: const TextStyle(
                          fontFamily: "InterBold",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dropdownBox() {
    return GestureDetector(
      onTap: () {
        showCategoryBottomSheet();
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: HexColor(AppColor.colorInputBg), // same as input
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: HexColor(AppColor.colorInputBorder),
            width: 1,
          ),
        ),
        child: Row(
          children: [

            /// TEXT
            Expanded(
              child: Text(
                selectedCategory?.name ?? "Select Category",
                style: TextStyle(
                  fontFamily: "InterRegular",
                  fontSize: 14,
                  color: selectedCategory == null
                      ? HexColor(AppColor.colorInputHint)
                      : Colors.black,
                ),
              ),
            ),

            /// DROPDOWN ICON
            Icon(Icons.keyboard_arrow_down,
                color: HexColor(AppColor.colorInputBorder)),
          ],
        ),
      ),
    );
  }


  void showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          clipBehavior: Clip.hardEdge, // 🔥 remove border line
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [

              /// 🔹 TOP HANDLE + CLOSE
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
                child: Row(
                  children: [

                    /// HANDLE
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    /// CLOSE BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20),
                    )
                  ],
                ),
              ),

              /// 🔹 TITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Select Category",
                      style: TextStyle(
                        fontFamily: "InterBold",
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 CATEGORY LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final cat = allCategories[index];
                    final isSelected =
                        selectedCategory?.name == cat.name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = cat;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 54, 113, 232)
                              .withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color.fromARGB(255, 54, 113, 232)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [

                            /// 🔹 NAME
                            Expanded(
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  fontFamily: "InterMedium",
                                  fontSize: 14,
                                  color: isSelected
                                      ? const Color.fromARGB(
                                      255, 54, 113, 232)
                                      : Colors.black,
                                ),
                              ),
                            ),

                            /// 🔹 CHECK ICON
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 54, 113, 232),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addCategory() {
    if (selectedCategory == null) return;

    if (selectedCategories.any((e) => e.name == selectedCategory!.name)) {
      return;
    }

    setState(() {
      selectedCategories.add(
        CategoryModel(
          name: selectedCategory!.name,
          subCategories: selectedCategory!.subCategories
              .map((e) => SubCategoryModel(name: e.name))
              .toList(),
        ),
      );
    });
  }

  void onSubmit() {
    final json = generateJson();
    print(json);
  }

  Map<String, dynamic> generateJson() {
    Map<String, dynamic> result = {};

    for (var cat in selectedCategories) {
      List<String> selectedSubs = [];

      for (var sub in cat.subCategories) {
        if (sub.isSelected) {
          selectedSubs.add(sub.name);
        }
      }

      if (selectedSubs.isNotEmpty) {
        result[cat.name] = selectedSubs;
      }
    }

    return result;
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      dateController.text = "${date.day}/${date.month}/${date.year}";
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      timeController.text = time.format(context);
    }
  }
}

