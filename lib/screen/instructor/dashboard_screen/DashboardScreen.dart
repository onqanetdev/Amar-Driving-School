import 'package:amar_driving_school/bloc/instructor/mocktest_list/instructor_mocktest_list_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/todays_lesson/instructor_todays_lesson_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/todays_lesson/instructor_todays_lesson_state.dart';
import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_state.dart';
import 'package:amar_driving_school/bloc/instructor/upload_training_report/instructor_upload_training_report_bloc.dart';
import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/screen/instructor/lesson_screen/LessonScreen.dart';
import 'package:amar_driving_school/screen/instructor/lesson_screen/TodaysLessonList.dart';
import 'package:amar_driving_school/screen/instructor/mock_test_screen/TodaysMocktestScreen.dart';
import 'package:amar_driving_school/screen/instructor/profile_screen/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/common/invoice/user_invoice_dart.dart';
import '../../../bloc/common/profile_bloc.dart';
import '../../../bloc/instructor/add_student/instructor_add_student_bloc.dart';
import '../../../bloc/instructor/delete_student/instructor_student_delete_bloc.dart';
import '../../../bloc/instructor/forget_password/instructor_forget_password_bloc.dart';
import '../../../bloc/instructor/instructor_register_bloc.dart';
import '../../../bloc/instructor/instructor_revenue/instructor_total_revenue_bloc.dart';
import '../../../bloc/instructor/instructor_revenue/instructor_total_revenue_event.dart';
import '../../../bloc/instructor/instructor_revenue/instructor_total_revenue_state.dart';
import '../../../bloc/instructor/lesson_delete/instructor_lesson_delete_bloc.dart';
import '../../../bloc/instructor/lesson_list/instructor_lesson_list_bloc.dart';
import '../../../bloc/instructor/login_instructor/instructor_login_bloc.dart';
import '../../../bloc/instructor/mocktest_delete/instructor_mocktest_delete_bloc.dart';
import '../../../bloc/instructor/mocktest_edit/instructor_update_mocktest_bloc.dart';
import '../../../bloc/instructor/reset_password/instructor_reset_password_bloc.dart';
import '../../../bloc/instructor/student_list/instructor_student_list_bloc.dart';
import '../../../bloc/instructor/student_total_count/instructor_student_count_bloc.dart';
import '../../../bloc/instructor/student_total_count/instructor_student_count_event.dart';
import '../../../bloc/instructor/student_total_count/instructor_studentcount_state.dart';
import '../../../bloc/instructor/todays_lesson/instructor_todays_lesson_event.dart';
import '../../../bloc/instructor/todays_mocktest/instructor_todays_mocktest_event.dart';
import '../../../bloc/student/student_login/student_login_bloc.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../model/LessonModel.dart';
import '../../../model/MockTestModel.dart';
import '../../../model/instructor_todays_lesson_model/instructor_todays_lesson_model.dart';
import '../../../model/instructor_todays_mocktest_model/instructor_todays_mocktest_model.dart';
import '../../common_screen/login_screen/LoginScreen.dart';
import '../add_student_screen/AddStudentScreen.dart';
import '../invoice_screen/InvoiceScreen.dart';
import '../mock_test_screen/MockTestScreen.dart';
import '../student_list_screen/StudentListScreen.dart';
import '../upload_training_screen/UploadTrainingScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool isLessonLoading = true;
  String lessonEmptyMessage = "";
  bool isMockLoading = true;
  String mockEmptyMessage = "";

  final ScrollController _mockTestScrollController = ScrollController();

  int totalStudents = 0;
  double totalRevenue = 0;
  int _currentIndex = 0;
  double _scale = 1.0;

  bool isUploadReport = false;

  /// ADD SCREENS LIST (ADD HERE)
  List<Widget> get _screens => [
    Column(
      children: [
        _header(),
        Expanded(child: bodyContent()),
      ],
    ),


    MultiBlocProvider(

      providers: [

        BlocProvider(
          create: (_) => InstructorLessonListBloc(),
        ),

        BlocProvider(
          create: (_) => InstructorLessonDeleteBloc(),
        ),

         BlocProvider(
                  create: (_) => InstructorRegBloc(),
                ),

                BlocProvider(
                  create: (_) => InstructorLoginBloc(),
                ),
      ],

     child: Todayslessonlist(),
     // child: LessonScreen(),
    ),

    MultiBlocProvider(

      providers: [

        BlocProvider(

          create: (_) =>
              InstructorMocktestListBloc(),
        ),

        BlocProvider(

          create: (_) =>
              InstructorMocktestDeleteBloc(),
        ),

        BlocProvider(create: (_) => InstructorUpdateMocktestBloc(),),

      ],

      //child: MockTestScreen(),
      child: Todaysmocktestscreen(),
    ),

    BlocProvider(

      create: (_) => ProfileBloc(),

      child: const ProfileScreen(),
    )
    //MockTestScreen(),
   // ProfileScreen(),
  ];


  List<TodaysLessonData> lessonList = [ ];

  List<TodaysMocktestData> mockList = [
  ];


  @override
  void initState() {
    super.initState();
   // _loadData();
    fetchTotalStudentCount();
    fetchTotalRevenue();
    fetchTodaysLesson();
    fetchTodaysMocktest();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await showDialog(
          context: context,
          builder: (_) => _exitDialog(context),
        );

        if (shouldExit == true) {
          Navigator.pop(context); // 👉 close app
        }
      },

      child:
      MultiBlocListener(

        listeners: [

          BlocListener<InstructorStudentCountBloc, InstructorStudentCountState>(

            listener: (context, state) {

              if(state
              is InstructorStudentCountSuccess) {

                setState(() {

                  totalStudents = int.parse(
                    state.totalStudentResponse
                        .totalStudent,
                  );
                });
              }
            },
          ),

          BlocListener<InstructorTotalRevenueBloc, InstructorTotalRevenueState>(

            listener: (context, state) {

              if(state
              is InstructorTotalRevenueSuccess) {

                setState(() {

                  totalRevenue = state.totalRevenueResponse.totalRevenue.toDouble();
                });

              }
            },
          ),

          //Instructor Todays Lesson
          BlocListener<InstructorTodaysLessonBloc, InstructorTodaysLessonState>(

            listener: (context, state) {

              if(state is InstructorTodaysLessonSuccess) {

                // setState(() {
                //   lessonList = state.todaysLessonResponse.data ;
                // });

                setState(() {

                  lessonList =
                      state.todaysLessonResponse.data;

                  lessonEmptyMessage = "";

                  isLessonLoading = false;
                });

              }

              if (state is InstructorTodaysLessonFailure) {

                setState(() {

                  lessonList.clear();

                  lessonEmptyMessage =
                      state.error.replaceAll(
                        "Exception: ",
                        "",
                      );

                  isLessonLoading = false;
                });
              }
            },
          ),

          //Instructor Mocktest List
          BlocListener<InstructorTodaysMocktestBloc, InstructorTodaysMocktestState>(

            listener: (context, state) {

              if(state is InstructorTodaysMocktestSuccess) {

                setState(() {

                  mockList =
                      state.todaysMocktestResponse.data;

                  mockEmptyMessage = "";

                  isMockLoading = false;
                });

              }

              if (state is InstructorTodaysMocktestFailure) {

                setState(() {

                  mockList.clear();

                  mockEmptyMessage =
                      state.error.replaceAll(
                        "Exception: ",
                        "",
                      );

                  isMockLoading = false;
                });
              }
            },
          ),
        ],
        child:        Scaffold(
          backgroundColor: Color.fromARGB(255, 233, 233, 233),

          /// ---------------- BODY ----------------
          /*body: Column(
          children: [
            _header(),
            bodyContent(),
          ],
        ),*/
          body: _screens[_currentIndex],

          /// ---------------- BOTTOM NAV (UNCHANGED) ----------------
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: HexColor(AppColor.colorOfToday),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,

            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/app_icons/ic_home.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorAppGray),
                ),
                activeIcon: Image.asset(
                  'assets/app_icons/ic_home.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorOfToday),
                ),
                label: "Home",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/app_icons/ic_lesson.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorAppGray),
                ),
                activeIcon: Image.asset(
                  'assets/app_icons/ic_lesson.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorOfToday),
                ),
                label: "My Lesson",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/app_icons/ic_mocktest.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorAppGray),
                ),
                activeIcon: Image.asset(
                  'assets/app_icons/ic_mocktest.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorOfToday),
                ),
                label: "Mocktest",
              ),

              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/app_icons/ic_profile.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorAppGray),
                ),
                activeIcon: Image.asset(
                  'assets/app_icons/ic_profile.png',
                  width: 24,
                  height: 24,
                  color: HexColor(AppColor.colorAppGray),
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exitDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 3, 61, 175).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.exit_to_app, size: 26, color: Color.fromARGB(255, 3, 61, 175)),
            ),

            const SizedBox(height: 12),

            const Text(
              "Exit App",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "InterBold",
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Are you sure you want to close the application?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                /// CANCEL
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// EXIT
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 54, 113, 232),
                              Color.fromARGB(255, 3, 61, 175)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- HEADER ----------------

  Widget _header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      padding: EdgeInsets.fromLTRB(
        10,
        MediaQuery.of(context).padding.top + 5, // ✅ FIXED
        10,
        0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 1, 70, 148),
            Color.fromARGB(255, 1, 9, 20)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/app_images/logo_of_amar.png',
            width: 60,
            color: Colors.white,
          ),
          SizedBox(width: 6),
          Text(
            'Amar driving school',
            style: TextStyle(color: Colors.white),
          ),
          Spacer(),

          AppButtonAnimation(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => _logoutDialog(context),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text("Logout", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _logoutDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔴 ICON
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 26,
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "InterBold",
              ),
            ),

            const SizedBox(height: 6),

            /// MESSAGE
            Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTONS
            Row(
              children: [

                /// CANCEL
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontFamily: "InterSemiBold"),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// LOGOUT
                Expanded(
                  child: InkWell(
                    onTap: () async {

                      Navigator.pop(context);

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [

                              BlocProvider(
                                create: (_) => InstructorRegBloc(),
                              ),

                              BlocProvider(
                                create: (_) => InstructorLoginBloc(),
                              ),

                              /// ADD THIS
                              BlocProvider(
                                create: (_) => StudentLoginBloc(),
                              ),

                              BlocProvider(
                                create: (_) => InstructorForgotPasswordBloc(),
                              ),

                              //Bloc Provider for Reset password
                              BlocProvider(
                                create: (_) => InstructorResetPasswordBloc(),
                              ),
                            ],
                            child: const LoginScreen(),
                          ),
                        ),
                            (route) => false,
                      );
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "InterBold",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- MAIN STACK ----------------

  Widget bodyContent() {
    return SingleChildScrollView( // ✅ removed Expanded
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/app_images/lady_driver.png'),

          Positioned(
            top: -100,
            left: 15,
            right: 15,
            child: _statsCard(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 270),

                _featureActionsSection(),

                SizedBox(height: 15),

                _subHeader("Lesson"),
                SizedBox(height: 10),
                _lessonList(),

                SizedBox(height: 25),

                _subHeader("Mocktest"),
                SizedBox(height: 10),
                _mockTestList(),

                SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// ---------------- LESSON ----------------

  Widget _lessonList() {
    if (isLessonLoading) {
      return _lessonShimmer();
    }

    // if (lessonList.isEmpty) return SizedBox();

    if (lessonList.isEmpty) {

      return emptyCard(
        lessonEmptyMessage.isEmpty
            ? "No Lesson Found"
            : lessonEmptyMessage,
      );
    }

    return SizedBox(
      height: 100, // 🔥 important for horizontal list
      child:
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lessonList.length,
        itemBuilder: (context, index) {
          final data = lessonList[index];

          return Container(
            width: MediaQuery.of(context).size.width * 0.85, // 🔥 card width
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 1, 70, 148),
                  Color.fromARGB(255, 1, 9, 20)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                /// PROFILE
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(255, 217, 217, 217),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/app_icons/user_black.png',
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),

                SizedBox(width: 8),

                /// DETAILS
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Text("Student name: ",
                              style: TextStyle(color: Colors.white)),
                          Expanded(
                            child: Text(
                              data.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: HexColor(AppColor.colorOfToday),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "Topic: ${data.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),

                      Text(
                        "Date: ${data.lessonStart}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _lessonShimmer() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          return buildShimmerLesson();
        },
      ),
    );
  }

  Widget buildShimmerLesson() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HexColor("${AppColor.colorWhite}"),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: HexColor(
              "${AppColor.colorAppGray}",
            ).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 16, height: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 60, height: 14, color: Colors.grey.shade400),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 14, height: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 100, height: 14, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 6),
          Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: double.infinity, height: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  /// ---------------- MOCKTEST ----------------

  Widget _mockTestList() {
    if (isMockLoading) {
      return _mockShimmer(); // ✅ FIXED
    }

    if (mockList.isEmpty) {

      return emptyCard(
        mockEmptyMessage.isEmpty
            ? "Mocktest Not Found!"
            : mockEmptyMessage,
      );
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child:
      ListView.builder(
        controller: _mockTestScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: mockList.length,
        itemBuilder: (context, index) {
          final item = mockList[index];

          return SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(255, 217, 217, 217),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/app_icons/user_black.png',
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
                SizedBox(height: 6),
                Text(item.name, overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _mockShimmer() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  /// ---------------- OTHER UI (UNCHANGED STYLE) ----------------

  Widget _subHeader(String title) {
    return Row(
      children: [

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              children: [
                TextSpan(
                    text: 'Today ',
                    style: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 14,
                      color: HexColor(AppColor.colorOfToday),
                    )
                ),
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "InterBold",
                    color: HexColor(AppColor.colorOfLesson),
                  ),
                )
              ]
          ),
        ),
        Spacer(),
        AppButtonAnimation(
          onTap: () async {
            if(title=="Lesson") {

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(

                    providers: [

                      BlocProvider(

                        create: (_) =>
                            InstructorTodaysLessonBloc(),
                      ),

                    ],

                    child: Todayslessonlist(showBack: true,),

                    // child: LessonScreen(
                    //   showBack: true,
                    // ),
                  ),
                ),
              );

              if (result == true) {
                fetchTodaysLesson();
              }

            }else{
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MultiBlocProvider(

                        providers: [

                          BlocProvider(
                            create: (_) =>
                                InstructorTodaysMocktestBloc(),
                          ),

                          // BlocProvider(
                          //
                          //   create: (_) =>
                          //       InstructorMocktestDeleteBloc(),
                          // ),
                        ],

                        //child: MockTestScreen(showBack: true,),
                        child: Todaysmocktestscreen(showBack: true,),
                      ),
                ),
              );

              if (result == true) {
                fetchTodaysMocktest();
              }

            }
          },
          child: Text('VIEW ALL', style: TextStyle(
              fontSize: 14,
              fontFamily: "InterSemiBold",
              color: HexColor("${AppColor.colorOfViewAll}")
          ),),
        )
      ],
    );
  }

  Widget _featureActionsSection() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: blueBox("Student List",'assets/app_icons/test_drive_steering.png')),
          SizedBox(width: 6,),
          Expanded(child: blueBox("Invoice Preview",'assets/app_icons/assign_mocktest.png')),
          if (isUploadReport)...[
          SizedBox(width: 6,),
          Expanded(child: blueBox("Upload Training Report",'assets/app_icons/checklist.png')),]
        ],
      ),
    );
  }

  Widget blueBox(String title, String iconPath) {
    return AppButtonAnimation(
      onTap: () async {
        if(title=="Student List") {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => InstructorAddStudentBloc(),
                  ),
                  BlocProvider(
                    create: (_) => InstructorStudentListBloc(),
                  ),
                  // Provider for delete Student
                  BlocProvider(create: (_) => InstructorStudentDeleteBloc(),),
                ],
                child: StudentListScreen(),
              ),
            ),
          );
          if (result == true) {
            fetchTotalStudentCount();
            fetchTotalRevenue();
          } else {
            fetchTotalRevenue();
            fetchTodaysLesson();
            fetchTodaysMocktest();
          }
        }else if(title=="Invoice Preview") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(
                  create: (_) => InstructorStudentListBloc(),
                ),

                BlocProvider(
                  create: (_) => UserInvoiceBloc(),
                ),
              ], child: InvoiceScreen())

                  //InvoiceScreen(),
            ),
          );
        }else if(title=="Upload Training Report") {
          Navigator.push(
            context,
            MaterialPageRoute(
              //builder: (_) => UploadTrainingScreen(),
              builder: (_) => MultiBlocProvider(providers: [
                BlocProvider(
                  create: (_) =>
                      InstructorStudentListBloc(),
                ),
                BlocProvider(
                  create: (_) =>
                      InstructorUploadTrainingReportBloc(),
                ),
              ],
                  child: UploadTrainingScreen()
              )
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 54, 113, 232),
              Color.fromARGB(255, 3, 61, 175)
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            SizedBox(
              width: 35,
              height: 35,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset(iconPath, color: Colors.white),
              ),
            ),
          
            SizedBox(height: 6),
          
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: AddStudentScreen(),
        );
      },
    );
  }


  Widget _statsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.fromLTRB(0, 230, 0, 0),
      padding: EdgeInsets.all(15),
      height: 110,
      child: Row(
        children: [
          /// Students Box
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(77, 158, 158, 158),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/app_icons/test_drive_steering.png',
                    width: 40,
                    color: HexColor(AppColor.colorOfAddStudent),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalStudents.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'InterBold',
                          color: HexColor(AppColor.colorOfAddStudent),
                        ),
                      ),
                      Text('Students'),
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(width: 10),

          /// Revenue Box
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(77, 158, 158, 158),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/app_icons/database_schema.png',
                    width: 30,
                    color: HexColor(AppColor.colorOfAddStudent),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹'+totalRevenue.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'InterBold',
                          color: HexColor(AppColor.colorOfAddStudent),
                        ),
                      ),
                      Text('Revenue'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget emptyCard(String title) {

    return Card(

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Center(

          child: Text(

            title,

            style: const TextStyle(
              fontSize: 14,
              fontFamily: "InterMedium",
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchTotalStudentCount() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    print(
      "🔥 Dashboard Instructor Id: $userId",
    );

    context.read<InstructorStudentCountBloc>().add(

      FetchInstructorStudentCount(

        instructorId:
        userId.toString(),
      ),
    );
  }
  Future<void> fetchTotalRevenue() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    context.read<
        InstructorTotalRevenueBloc>().add(

      FetchInstructorTotalRevenue(

        instructorId:
        userId.toString(),
      ),
    );
  }

  Future<void> fetchTodaysLesson() async {
    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    context.read<InstructorTodaysLessonBloc>().add(

      FetchInstructorTodaysLesson(
        instructorId:
        userId.toString(),
      ),
    );
  }
  Future<void> fetchTodaysMocktest() async {
    final prefs =
    await SharedPreferences.getInstance();

    final userId =
    prefs.getString('user_id');

    context.read<InstructorTodaysMocktestBloc>().add(

      FetchInstructorTodaysMocktest(
        instructorId:
        userId.toString(),
      ),
    );
  }
}