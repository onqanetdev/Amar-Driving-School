import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_event.dart';
import 'package:amar_driving_school/bloc/instructor/sub_topic_list/instructor_sub_topic_list_state.dart';
import 'package:amar_driving_school/bloc/instructor/topic_list/instructor_topic_list_state.dart';
import 'package:amar_driving_school/model/instructor_topic/instructor_topic_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/instructor/create_lesson/instructor_create_lesson_bloc.dart';
import '../../../bloc/instructor/create_lesson/instructor_create_lesson_event.dart';
import '../../../bloc/instructor/create_lesson/instructor_create_lesson_state.dart';
import '../../../bloc/instructor/lesson_edit/instructor_lesson_edit_bloc.dart';
import '../../../bloc/instructor/lesson_edit/instructor_lesson_edit_event.dart';
import '../../../bloc/instructor/lesson_edit/instructor_lesson_edit_state.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_event.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_state.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_bloc.dart';
import '../../../bloc/instructor/topic_list/instructor_topic_list_event.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/app_button_animation.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/CategoryModel.dart';
import '../../../model/LessonModel.dart';
import '../../../model/StudentModel.dart';
import '../../../model/SubCategoryModel.dart';
import '../../../model/instructor_create_lesson_model/instructor_Lesson_List_Model.dart';
import '../../../model/instructor_student_list/instructor_student_list_model.dart';
import '../../../model/instructor_topic/instructor_sub_topic_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_input_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLessonScreen extends StatefulWidget {
  final LessonData? lesson;
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

  bool isEdit = false;
  bool editDataLoaded = false;
  //Set<String> selectedSubTopicIds = {};

  @override
  initState(){
    super.initState();
    // selectedCategory?.name = widget.lesson!.name;
    loadInitialData();
    //showStudentList();
    if (widget.lesson != null) {
      /// 👉 EDIT MODE
      isEdit = true;
      print("The Edited File is ${isEdit}");
      titleController.text = widget.lesson!.name;
      dateController.text = widget.lesson!.classDate;
      timeController.text = widget.lesson!.lessonStart!;
      ///hourController.text = widget.lesson!.lessonStart!;
      /// PREFILL DURATION
      durationController.text = widget.lesson!.lessonDuration!;
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

                /// CONVERT API IDS
                // allSelectedSubTopic = widget.lesson!.subtopicId.split(',')
                //         .map((e) => e.trim())
                //         .toSet();

                //allSelectedSubTopic = widget.lesson!.subtopicId.split(',').map((e) => e.trim()).toSet();

                if (isEdit && !editDataLoaded) {
                  allSelectedSubTopic = widget.lesson!.subtopicId.split(',').map((e) => e.trim()).toSet();
                }

                // allSelectedSubTopic =
                //     widget.lesson!
                //         .subtopicId
                //         .split(',')
                //         .toSet();
              });
            }

            if(state is InstructorSubTopicListFailure) {
              LoaderHelper.hide(context);
              print('Sub Topic List Failure 😞');
            }
          },
        ),
        //Bloc Listener for category section
        BlocListener<InstructorTopicListBloc, InstructorTopicListState>(
          listener: (context, state) async {

            if(state is InstructorTopicListLoading) {
              LoaderHelper.show(context);
            }

            if(state is InstructorTopicListSuccess)  {
              LoaderHelper.hide(context);
              print("Selected Sub Topics Are : ${widget.lesson?.subtopicId}");
              // allSelectedSubTopic = Set(widget.lesson?.subtopicId);
              setState(() {

                allCategories =
                    state.topicListResponse.data;

                /// AUTO SELECT CATEGORY
                // selectedCategory =
                //     allCategories.firstWhere(
                //
                //           (e) =>
                //       e.id ==
                //           widget.lesson?.topicId,
                //     );
                //
                //
                //
                // /// CALL SUBTOPIC API
                // context
                //     .read<
                //     InstructorSubTopicListBloc>().add(
                //     FetchInstructorSubTopicList(
                //
                //       topicId: widget.lesson!.topicId,
                //     ),
                // );
                //
                // addCategory();
                // allSelectedSubTopic = widget.lesson!.subtopicId.split(',').map((e) => e.trim()).toSet();

                if (isEdit && !editDataLoaded) {

                  selectedCategory =
                      allCategories.firstWhere(
                            (e) => e.id == widget.lesson?.topicId,
                      );

                  context.read<InstructorSubTopicListBloc>().add(
                    FetchInstructorSubTopicList(
                      topicId: widget.lesson!.topicId,
                    ),
                  );

                  addCategory();

                  allSelectedSubTopic =
                      widget.lesson!.subtopicId
                          .split(',')
                          .map((e) => e.trim())
                          .toSet();

                  editDataLoaded = true;
                }


              }
              );
            }

            if (state is InstructorTopicListFailure) {
              print('Topic List Failure 😞');
            }
          },
        ),
        //Bloc Listener for  Student List
        BlocListener<InstructorStudentListBloc, InstructorStudentListState>(

          listener: (context, state) {

            /// LOADING
            if(state is InstructorStudentListLoading) {
              LoaderHelper.show(context);
            }

            /// SUCCESS
            if(state is InstructorStudentListSuccess) {

              LoaderHelper.hide(context);

              setState(() {

                /// STORE API DATA
                students =
                    state.studentListResponse.data;

                if(students.isNotEmpty) {

                  selectedStudent =
                      students.firstWhere(

                            (e) =>
                        e.userId ==
                            widget.lesson?.userId,

                        orElse: () => students.first,
                      );

                  /// UPDATE TEXTFIELD
                  studentListController.text =
                      selectedStudent?.name ?? "";

                  print(
                    "Selected name is ${selectedStudent?.name}",
                  );

                  print(
                    "Controller text is ${studentListController.text}",
                  );
                }
              });
            }

            /// FAILURE
            if(state is InstructorStudentListFailure) {
              print('Student List  Failure 😞');
            }
          },
        ),
        // Bloc Listener for Add Lesson
        BlocListener<InstructorCreateLessonBloc, InstructorCreateLessonState>(

          listener: (context, state) async {

            /// 🔥 LOADING
            if(state is InstructorCreateLessonLoading) {

              LoaderHelper.show(context);
            }

            /// 🔥 SUCCESS
            if(state is InstructorCreateLessonSuccess) {

              LoaderHelper.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(
                  content: Text(
                    state.createLessonResponse.message,
                  ),
                ),
              );

             Navigator.pop(context, true);
            //   if (!isEdit) {
            //     Navigator.pop(context);
            //   }
            }

            /// 🔥 FAILURE
            if(state is InstructorCreateLessonFailure) {

              LoaderHelper.hide(context);

              print('Create Failure 😞');

              ScaffoldMessenger.of(context).showSnackBar(

                SnackBar(
                  content: Text(state.error),
                ),
              );
            }
          },
        ),
        // Bloc Listener for Edit Lesoon
        BlocListener<InstructorLessonEditBloc, InstructorLessonEditState>(
          listener: (context, state) {

            if(state is InstructorLessonEditLoading) {

              LoaderHelper.show(context);
            }

            if(state is InstructorLessonEditSuccess) {

              LoaderHelper.hide(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(

                  content: Text(
                    state
                        .lessonEditResponse
                        .message,
                  ),
                ),
              );

              /// OPTIONAL
              Navigator.pop(context, true);
            }

            if(state is InstructorLessonEditFailure) {

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

                                              selectedCategory = null;

                                              selectedCategories.clear();

                                              allSubCategories.clear();

                                              allSelectedSubTopic.clear();

                                              // reset subtopic selection state
                                              for (var sub in allSubCategories) {
                                                sub.isSelected = false;
                                              }
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

                            AppInputField(
                              controller: studentListController,
                              hintText: "Student Name",
                              readOnly: true,            // 🔥 disable typing
                              onTap: showStudentList,    // 🔥 open dialog

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
                              onTap: isEdit ? onSubmitEdit : onSubmit,
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
                      onTap: () => Navigator.pop(context, true),
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
                        Navigator.pop(context,true);
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

//This Submit is for Create Lesson
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

    // final parsedDate = DateFormat("d/M/yyyy").parse(dateController.text.trim());
    //
    // final formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

    final formattedDate = dateController.text.trim();

    print("Converted Date => $formattedDate");


    print(
      'The selected Ids are : $allSelectedSubTopic, '
          'topic id is ${selectedCategory?.id}, '
          'the title is ${titleController.text}, '
          'date is ${dateController.text}, '
          'Start Time is ${timeController.text}, '
          'Selected duration is ${durationController.text}, '
          'Student User id is $studentUserId, '
          'Teacher id is $userId',
    );

    /// 🔥 API CALL
    context.read<InstructorCreateLessonBloc>().add(

      InstructorCreateLessonTapped(

        userid: studentUserId.toString(),

        instructorid: userId.toString(),

        //name: titleController.text.trim(),

        startDate: formattedDate,

        startTime: timeController.text.trim(),

        duration: durationController.text.trim(),

        topicId: selectedCategory!.id,

        subtopicId:
        allSelectedSubTopic.join(","),

      ),
    );
  }
  //This Submit for Edit Lesson
  Future<void> onSubmitEdit() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');

    studentUserId = widget.lesson!.userId;

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
      'The selected Ids for Edit Lesson are : $allSelectedSubTopic, '
          'topic ids Are for Edit Lesson ${selectedCategory?.id}, '
          'the title is for Edit lesson ${titleController.text}, '
          'date is for Edit Lesson${dateController.text}, '
          'Start Time is Edit Lesson ${timeController.text}, '
          'Selected duration is For Edit Lesson ${durationController.text}, '
          'Student User id is For Edit Lesson  $studentUserId, '
          'Teacher id is for Edit Lesson $userId',
    );



    final formattedDate = dateController.text.trim();

    print("Converted Edit Date => $formattedDate");

    /// 🔥 API CALL
    context.read<InstructorLessonEditBloc>().add(

      InstructorLessonEditTapped(

        userid: studentUserId.toString(),

        instructorid: userId.toString(),

        //name: titleController.text.trim(),

        startDate: formattedDate,

        startTime: timeController.text.trim(),

        duration: durationController.text.trim(),

        topicId: selectedCategory!.id,

        subtopicId:
        allSelectedSubTopic.join(","),

      ),
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
     // dateController.text = "${date.day}/${date.month}/${date.year}";
      dateController.text =
          DateFormat("yyyy-MM-dd").format(date);
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

    final userId =
    prefs.getString('user_id');

    context.read<InstructorTopicListBloc>().add(
      FetchInstructorTopicList(),
    );

    context.read<InstructorStudentListBloc>().add(
      FetchInstructorStudentList(
        instructureId: userId!,
      ),
    );
  }
  /// 🔥 STUDENT BOTTOM SHEET
  Future<void> showStudentList() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [

              /// 🔹 HANDLE + CLOSE
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [

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

                    GestureDetector(
                      onTap: () => Navigator.pop(context, true),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
              ),

              /// 🔹 TITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Student",
                    style: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔹 STUDENT LIST
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedStudent = student;
                          studentListController.text = student.name;
                          studentUserId = student.userId ;
                        });
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [

                            /// 🔹 AVATAR
                            const CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.person, size: 18),
                            ),

                            const SizedBox(width: 10),

                            /// 🔹 DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontFamily: "InterBold",
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    student.phone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// 🔹 AMOUNT
                            Text(
                              "₹${student.amount}",
                              style: const TextStyle(
                                fontFamily: "InterBold",
                                color: Color.fromARGB(
                                    255, 54, 113, 232),
                              ),
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
}
