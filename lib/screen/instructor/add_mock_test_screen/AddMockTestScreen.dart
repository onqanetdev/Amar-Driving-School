import 'package:amar_driving_school/bloc/instructor/create_mocktest/instructor_create_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/create_mocktest/instructor_create_mocktest_state.dart';
import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/model/student_all_model/student_mocktest_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/instructor/create_mocktest/instructor_create_mocktestEvent.dart';
import '../../../bloc/instructor/mocktest_edit/instructor_update_mocktest_bloc.dart';
import '../../../bloc/instructor/mocktest_edit/instructor_update_mocktest_event.dart';
import '../../../bloc/instructor/mocktest_edit/instructor_update_mocktest_state.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import '../../../bloc/instructor/sub_topic_list/instructor_sub_topic_list_event.dart';
import '../../../bloc/instructor/sub_topic_list/instructor_sub_topic_list_state.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_event.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/CategoryModel.dart';
import '../../../model/LessonModel.dart';
import '../../../model/SubCategoryModel.dart';
import '../../../model/instructor_create_mocktest/instructor_mocktest_list_model.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../model/instructor_topic/instructor_sub_topic_list_model.dart';
import '../../../model/instructor_topic/instructor_topic_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMockTestScreen extends StatefulWidget {
  final StudentMocktestData? mocktest;
  final String? studentName;
  final String? studentCode;
  const AddMockTestScreen({super.key,this.mocktest, this.studentName, this.studentCode});

  @override
  State<AddMockTestScreen> createState() => _AddMockTestScreenState();
}

class _AddMockTestScreenState extends State<AddMockTestScreen> {

 // final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final hourController = TextEditingController();
  final minController = TextEditingController();
  final studentListController = TextEditingController();

  final durationController = TextEditingController();

  TopicData? selectedCategory;
  List<TopicData> selectedCategories = [];


  List<TopicData> allCategories = [

  ];

  List<SubTopicData> allSubCategories = [

  ];

  //List<String> allSelectedSubTopic = [ ];
  Set<String> allSelectedSubTopic = {};

  StudentData? selectedStudent;

  List<StudentData> students = [];
  String studentUserId = '';

  //Sample  varibale

  bool isEdit = false;
  bool editDataLoaded = false;


  @override
  void initState() {
    super.initState();

    loadInitialData();

    if (widget.mocktest != null) {

      isEdit = true;

      dateController.text =
          widget.mocktest!.classDate ?? '';

      timeController.text =
          widget.mocktest!.lessonStart ?? '';

      durationController.text =
          widget.mocktest!.duration ?? '';
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

            if(state is InstructorSubTopicListSuccess) {

              LoaderHelper.hide(context);

              setState(() {

                allSubCategories =
                    state.subTopicListResponse.data;

                if (isEdit) {

                  allSelectedSubTopic =
                  (widget.mocktest!.subtopicId ?? '').split(',')
                          .map((e) => e.trim())
                          .toSet();
                }
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


            if (state is InstructorTopicListSuccess) {

              setState(() {

                allCategories =
                    state.topicListResponse.data;

                if (isEdit && !editDataLoaded) {

                  selectedCategory =
                      allCategories.firstWhere(
                            (e) =>
                        e.id ==
                            widget.mocktest?.topicId,
                      );

                  context
                      .read<
                      InstructorSubTopicListBloc>()
                      .add(
                    FetchInstructorSubTopicList(
                      topicId:
                      (widget.mocktest!.topicId ?? ''),
                    ),
                  );

                  addCategory();

                  allSelectedSubTopic =
                  (widget.mocktest!.subtopicId ?? '')
                          .split(',')
                          .map((e) => e.trim())
                          .toSet();

                  editDataLoaded = true;
                }
              });
            }

          },
        ),
        // Bloc Listener for Add Lesson
        BlocListener<InstructorCreateMocktestBloc, InstructorCreateMocktestState>(

          listener: (context, state) async {

            /// 🔥 LOADING
            if(state is InstructorCreateMocktestLoading) {

              LoaderHelper.show(context);
            }

            /// 🔥 SUCCESS
            if(state is InstructorCreateMocktestSuccess) {

              LoaderHelper.hide(context);
              Helper.showToast(context, state.createMocktestResponse.message);

              //Navigator.pop(context);
              Navigator.pop(context, true);
            }

            /// 🔥 FAILURE
            if(state is InstructorCreateMocktestFailure) {

              LoaderHelper.hide(context);
              Helper.showToast(context, state.error,);

            }
          },
        ),
        // Bloc Listener for Edit Mocktest
        BlocListener<InstructorUpdateMocktestBloc, InstructorUpdateMocktestState>(

          listener: (context, state) async {

            if(state is InstructorUpdateMocktestLoading) {

              LoaderHelper.show(context);
            }

            if(state is InstructorUpdateMocktestSuccess) {

              LoaderHelper.hide(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(
                  content: Text(
                    state.updateMocktestResponse
                        .message,
                  ),
                ),
              );

              Navigator.pop(context, true);
            }

            if(state is InstructorUpdateMocktestFailure) {

              LoaderHelper.hide(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(

                  content: Text(
                    state.error,
                  ),

                  backgroundColor:
                  Colors.red,
                ),
              );
            }
          },
        ),
      ],
          child: Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),

            body: Column(
              children: [

                /// HEADER
                AppHeader(
                  title: "Create Mocktest",
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
                                        //  final isSelected = sub.isSelected;
                                          final isSelected = allSelectedSubTopic.contains(sub.id);
                                          return GestureDetector(
                                            onTap: () {
                                              print('the sub topic id is ${sub.id}, and the topic id is ${sub.topicId}');
                                              //
                                              // if (sub.isSelected == false) {
                                              //   allSelectedSubTopic.add(sub.id);
                                              // } else {
                                              //   allSelectedSubTopic.remove(sub.id);
                                              // }
                                              // print(allSelectedSubTopic);
                                              //
                                              // setState(() {
                                              //   //sub.isSelected = !sub.isSelected;
                                              //   if (allSelectedSubTopic.contains(sub.id)) {
                                              //     allSelectedSubTopic.remove(sub.id);
                                              //   } else {
                                              //     allSelectedSubTopic.add(sub.id);
                                              //   }
                                              // });

                                              setState(() {

                                                if (allSelectedSubTopic.contains(sub.id)) {

                                                  allSelectedSubTopic.remove(sub.id);

                                                } else {

                                                  allSelectedSubTopic.add(sub.id);

                                                }

                                                print(allSelectedSubTopic);
                                              });


                                            }, //on tap
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
                            // AppInputField(
                            //   controller: titleController,
                            //   hintText: "Advance Car Drive",
                            //   fillColor: AppColor.colorInputBg,
                            //   borderColor: AppColor.colorInputBorder,
                            //   focusedBorderColor: AppColor.colorInputFocusBorder,
                            //   hintColor: AppColor.colorInputHint,
                            //   borderRadius: 10,
                            //   obscureText: false,
                            //   keyboardType: TextInputType.text,
                            // ),

                            const SizedBox(height: 10),

                            AppInputField(
                              controller: studentListController,
                              hintText: "Student Name",
                              readOnly: true,            // 🔥 disable typing
                              //onTap: showStudentList,    // 🔥 open dialog

                              fillColor: AppColor.colorInputBg,
                              borderColor: AppColor.colorInputBorder,
                              focusedBorderColor: AppColor.colorInputFocusBorder,
                              hintColor: AppColor.colorInputHint,

                              suffixWidget: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
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
                                    controller: durationController,
                                    hintText: "Select Duration",
                                    readOnly: true,
                                    onTap: pickDuration,
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
                              onTap: isEdit
                                  ? onSubmitMocktestEdit
                                  : onSubmit,
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


  Future<void> onSubmit() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    /// 🔥 VALIDATIONS

    if(selectedCategory == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select category"),
        ),
      );

      return;
    }

    if(allSelectedSubTopic.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select sub topic"),
        ),
      );

      return;
    }

    // if(titleController.text.trim().isEmpty) {
    //
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Please enter lesson title"),
    //     ),
    //   );
    //
    //   return;
    // }

    if(studentListController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select student"),
        ),
      );

      return;
    }

    if(dateController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select date"),
        ),
      );

      return;
    }

    if(timeController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select start time"),
        ),
      );

      return;
    }

    if(durationController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select duration"),
        ),
      );

      return;
    }

    if(studentUserId == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select student"),
        ),
      );

      return;
    }

    print(
      '🛜🛜🛜🛜The selected Ids are : $allSelectedSubTopic, '
          'topic id is ${selectedCategory?.id}, '
          //'the title is ${titleController.text}, '
          'date is ${dateController.text}, '
          'Start Time is ${timeController.text}, '
          'Selected duration is ${durationController.text}, '
          'Student User id is $studentUserId, '
          'Teacher id is $userId',
    );

    final inputDate = dateController.text.trim();

    final parsedDate = DateFormat("d/M/yyyy").parse(inputDate);

    final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

    print("Converted Date => $formattedDate");




    /// 🔥 API CALL
    context.read<InstructorCreateMocktestBloc>().add(

      InstructorCreateMocktestTapped(

        userid: widget.studentCode ?? '',

        instructorid: userId.toString(),

        //Fname: titleController.text.trim(),

        //startDate: dateController.text.trim(),
        startDate: formattedDate,

        startTime: timeController.text.trim(),

        duration: durationController.text.trim(),

        topicId: selectedCategory!.id,

        subtopicId: allSelectedSubTopic.join(","),

      ),
    );
  }

  Future<void> onSubmitMocktestEdit() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    print("🔥 UPDATE BUTTON CLICKED");

    /// VALIDATIONS

    if (selectedCategory == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select category",
          ),
        ),
      );

      return;
    }

    if (allSelectedSubTopic.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select sub topic",
          ),
        ),
      );

      return;
    }

    if (studentListController.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select student",
          ),
        ),
      );

      return;
    }

    if (dateController.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select date",
          ),
        ),
      );

      return;
    }

    if (timeController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select start time",
          ),
        ),
      );

      return;
    }

    if (durationController.text
        .trim()
        .isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select duration",
          ),
        ),
      );

      return;
    }

    print(
      'Selected Sub Topics: $allSelectedSubTopic\n'
          'Topic Id: ${selectedCategory?.id}\n'
          'Date: ${dateController.text}\n'
          'Time: ${timeController.text}\n'
          'Duration: ${durationController.text}\n'
          'Student Id: $studentUserId\n'
          'Instructor Id: $userId',
    );

    context.read<InstructorUpdateMocktestBloc>().add(

      InstructorUpdateMocktestTapped(

        userid: widget.studentCode ?? '',

        instructorid:
        userId.toString(),

        startDate:
        dateController.text.trim(),

        startTime:
        timeController.text.trim(),

        duration:
        durationController.text.trim(),

        topicId:
        selectedCategory!.id,

        subtopicId:
        allSelectedSubTopic.join(","),
      ),
    );
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


  Future<void> pickDuration() async {

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.now(),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {

      setState(() {

        durationController.text =
        "${picked.hour.toString().padLeft(2, '0')}:"
            "${picked.minute.toString().padLeft(2, '0')}";

      });
    }
  }

  Future<void> loadInitialData() async {

    final prefs =
    await SharedPreferences.getInstance();

    studentListController.text = widget.studentName ?? '' ;

    final userId =
    prefs.getString('user_id');

    context.read<InstructorTopicListBloc>().add(
      FetchInstructorTopicList(),
    );

    // context.read<InstructorStudentListBloc>().add(
    //   FetchInstructorStudentList(
    //     instructureId: userId!,
    //   ),
    // );
  }

}

