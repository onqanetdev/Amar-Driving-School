import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_event.dart';
import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_state.dart';
import 'package:amar_driving_school/bloc/instructor/topic_list/instructor_topic_list_state.dart';
import 'package:amar_driving_school/model/instructor_topic/instructor_topic_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_event.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/app_button_animation.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/CategoryModel.dart';
import '../../../model/LessonModel.dart';
import '../../../model/SubCategoryModel.dart';
import '../../../model/instructor_topic/instructor_sub_topic_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';

class AddLessonScreen extends StatefulWidget {
  final LessonModel? lesson;
  const AddLessonScreen({super.key,this.lesson});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final hourController = TextEditingController();
  final minController = TextEditingController();

  TopicData? selectedCategory;
  List<TopicData> selectedCategories = [];


  List<TopicData> allCategories = [

  ];

  List<SubTopicData> allSubCategories = [

  ];

  //List<String> allSelectedSubTopic = [ ];
  Set<String> allSelectedSubTopic = {};

  @override
  void initState() {
    super.initState();

    context.read<InstructorTopicListBloc>().add(
      FetchInstructorTopicList(),
    );

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
    return
      MultiBlocListener(listeners: [
        //Bloc Listener for Sub Category section
        BlocListener<InstructorSubTopicListBloc, InstructorSubTopicListState>(
          listener: (context, state) async {

            if(state is InstructorSubTopicListLoading) {
              LoaderHelper.show(context);
            }

            if(state is InstructorSubTopicListSuccess)  {
              LoaderHelper.hide(context);
              setState(() {
                allSubCategories = state.subTopicListResponse.data;
              });

            }

            if(state is InstructorSubTopicListFailure) {
              LoaderHelper.hide(context);
            }
          },
        ),
        //Bloc Listener for category section
        BlocListener<InstructorTopicListBloc, InstructorTopicListState>(
          listener: (context, state) async {


            if(state is InstructorTopicListSuccess)  {
              // LoaderHelper.hide(context);
              //allSubCategories = state.subTopicListResponse.data;
              setState(() {

                allCategories =
                    state.topicListResponse.data;
              });
            }

          },
        )
      ],
          child: Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),

            body: Column(
              children: [

                /// HEADER
                AppHeader(
                  title: "Create Lesson",
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

                            dropdownBox(),
                            const SizedBox(height: 10),

                            selectedCategory?.name == null?
                            Visibility(
                              child: subcategoryBox(),
                              visible: false,
                            ): Visibility(
                              child: subcategoryBox(),
                              visible: true,
                            ),

                            const SizedBox(height: 10),

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

                                        ...List.generate(allSubCategories.length, (index) {
                                          //final sub = cat.subCategories[index];
                                          final sub = allSubCategories[index];
                                          final isSelected = sub.isSelected;

                                          return GestureDetector(
                                            onTap: () {
                                              print('the sub topic id is ${sub.id}, and the topic id is ${sub.topicId}');
                                              if (sub.isSelected == false) {
                                                allSelectedSubTopic.add(sub.id);
                                              } else {
                                                allSelectedSubTopic.remove(sub.id);
                                              }
                                              print(allSelectedSubTopic);
                                              setState(() {
                                                sub.isSelected = !sub.isSelected;
                                              });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 6),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: isSelected ? const Color.fromARGB(255, 54, 113, 232).withOpacity(0.1) : Colors.white,
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
                                                      color: isSelected ? const Color.fromARGB(255, 54, 113, 232) : Colors.black,
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
                            /// 🔥 SELECTED CATEGORY
                            /// 🔥 SELECTED CATEGORY (PRO UI)
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
          )
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


  /// Sub category Dropdown

  Widget subcategoryBox() {
    return GestureDetector(
      onTap: () {
        addCategory();
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
                 "Select Sub Category",
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
            //color: Colors.pink,
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
      context.read<InstructorSubTopicListBloc>().add(
        FetchInstructorSubTopicList(topicId: selectedCategory!.id)
      );

      selectedCategories.add(
        TopicData(id: selectedCategory!.id, name: selectedCategory!.name, slug: selectedCategory!.slug, status: selectedCategory!.status)

      );
    });
  }

  void onSubmit() {
    final json = generateJson();

    print('The selected Ids are : ${allSelectedSubTopic}, '
        'topic id is  ${selectedCategory?.id}, '
        'the title is ${titleController.text} , '
        'date is ${dateController.text}, '
        'Start Time is ${timeController.text} , Selected Hour is ${hourController.text}, '
        'Selected Minutes is ${minController.text}',

    );
  }

  Map<String, dynamic> generateJson() {
    Map<String, dynamic> result = {};

    for (var cat in selectedCategories) {
      List<String> selectedSubs = [];

      // for (var sub in cat.subCategories) {
      //   if (sub.isSelected) {
      //     selectedSubs.add(sub.name);
      //   }
      // }

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
