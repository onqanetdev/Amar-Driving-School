import 'package:amar_driving_school/helper/app_button_animation.dart';
import 'package:amar_driving_school/screen/Student/profile_screen/ProfileScreen.dart';
import 'package:amar_driving_school/screen/common_screen/login_screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/instructor/instructor_register_bloc.dart';
import '../../../bloc/instructor/login_instructor/instructor_login_bloc.dart';
import '../../../bloc/student/lesson_list/student_lesson_list_bloc.dart';
import '../../../bloc/student/mocktest_list/student_mocktest_list_bloc.dart';
import '../../../bloc/student/student_login/student_login_bloc.dart';
import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_bloc.dart';
import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_event.dart';
import '../../../bloc/student/todays_lesson_list/student_todays_lesson_list_state.dart';
import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_bloc.dart';
import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_event.dart';
import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_state.dart';
import '../../../bloc/student/total_lesson_count/student_total_lesson_count_bloc.dart';
import '../../../bloc/student/total_lesson_count/student_total_lesson_count_event.dart';
import '../../../bloc/student/total_lesson_count/student_total_lesson_count_state.dart';
import '../../../bloc/student/total_mocktest_count/student_total_mocktest_count_bloc.dart';
import '../../../bloc/student/total_mocktest_count/student_total_mocktest_count_event.dart';
import '../../../bloc/student/total_mocktest_count/student_total_mocktest_count_state.dart';
import '../../../common/app_color.dart';
import '../../../common/convert_color.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/LessonModel.dart';
import '../../../model/MockTestModel.dart';
import '../../../model/student_all_model/student_todays_lesson_list_model.dart';
import '../../../model/student_all_model/student_todays_lesson_mocktest_list_model.dart';
import '../../../widgets/app_button.dart';
import '../../student/mock_test_screen/MockTestScreen.dart';
import '../lesson_screen/LessonScreen.dart';
import '../mock_test_reports_screen/MockTestReportsScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {

  final ScrollController _mockTestScrollController = ScrollController();

  String totalLesson = '5';
  String totalMocktest = '7';
  double totalRevenue = 1270;
  int _currentIndex = 0;
  double _scale = 1.0;

  bool isLessonLoading = true;
  bool isMockLoading = true;

  /// ADD SCREENS LIST (ADD HERE)
  List<Widget> get _screens => [
    Column(
      children: [
        _header(),
        Expanded(child: bodyContent()),
      ],
    ),

  MultiBlocProvider(providers: [
  BlocProvider(
    create: (_) => StudentLessonListBloc(),
  ),],
    child:  LessonScreen(),
  ),

   // LessonScreen(),
    //MockTestScreen(),
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) =>
            StudentMocktestListBloc(),
      ),
    ], child: MockTestScreen()
    ),

    ProfileScreen(),
  ];


  /// Dummy Data

  List<StudentTodaysLessonData> lessonList = [];


   //List<StudentTodaysMocktestData> mockList = [ ];

  // final List<LessonModel> lessons = List.generate(
  //   5,
  //       (index) => LessonModel(
  //     name: "Car Drive Mocktest",
  //     duration: "1hr",
  //     date: "18.04.2026",
  //     time: "10:30AM",
  //   ),
  // );


  List<StudentTodaysMocktestData> lessons = [ ];


  void _loadData() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    setState(() {
      isLessonLoading = false;
      isMockLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();

    fetchTotalLessonCount();

    fetchTotalMocktestCount();

    fetchTodaysLessonList();
    fetchTodaysMocktestList();
  }

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocListener(

          listeners: [

            /// TOTAL LESSON COUNT
            BlocListener<StudentTotalLessonCountBloc, StudentTotalLessonCountState>(

              listener: (context, state) {

                /// LOADING
                if(state is StudentTotalLessonCountLoading) {

                  LoaderHelper.show(context);
                }

                /// SUCCESS
                if(state is StudentTotalLessonCountSuccess) {

                  LoaderHelper.hide(context);

                  setState(() {

                    totalLesson = state.totalLessonCountResponse.data.toString();
                  });
                }

                /// FAILURE
                if(state is StudentTotalLessonCountFailure) {

                  LoaderHelper.hide(context);

                  print(state.error);
                }
              },
            ),

            /// MOCKTEST COUNT LISTENER
            BlocListener<StudentTotalMocktestCountBloc, StudentTotalMocktestCountState>(

              listener: (context, state) {

                /// LOADING
                if(state is StudentTotalMocktestCountLoading) {

                  LoaderHelper.show(context);
                }

                /// SUCCESS
                if(state is StudentTotalMocktestCountSuccess) {

                  LoaderHelper.hide(context);

                  setState(() {

                    totalMocktest = state.totalMocktestCountResponse.data.toString();
                  });
                }

                /// FAILURE
                if(state is StudentTotalMocktestCountFailure) {

                  LoaderHelper.hide(context);

                  print(state.error);
                }
              },
            ),

            /// TODAY'S LESSON LIST
            BlocListener<StudentTodaysLessonListBloc, StudentTodaysLessonListState>(

              listener: (context, state) {

                /// LOADING
                if(state is StudentTodaysLessonListLoading) {

                  LoaderHelper.show(context);
                }

                /// SUCCESS
                if(state is StudentTodaysLessonListSuccess) {

                  LoaderHelper.hide(context);
                  print('Lesson List ----->${state.todaysLessonListResponse.data}');
                  setState(() {
                    lessonList = state.todaysLessonListResponse.data;
                  });

                  print(
                    "Lesson List Length = ${lessonList.length}",
                  );
                }

                /// FAILURE
                if(state is StudentTodaysLessonListFailure) {

                  LoaderHelper.hide(context);

                  print(state.error);
                }
              },
            ),

            /// TODAY'S MOCKTEST LIST
            BlocListener<
                StudentTodaysMocktestListBloc, StudentTodaysMocktestListState>(

              listener: (context, state) {

                /// LOADING
                if(state is StudentTodaysMocktestListLoading) {

                  LoaderHelper.show(context);
                }

                /// SUCCESS
                if(state is StudentTodaysMocktestListSuccess) {

                  LoaderHelper.hide(context);

                  setState(() {

                    lessons = state.todaysMocktestListResponse
                            .data;
                  });
                }

                /// FAILURE
                if(state is StudentTodaysMocktestListFailure) {

                  LoaderHelper.hide(context);

                  print(state.error);
                }
              },
            ),

          ],


     child:  PopScope(
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


      child: Scaffold(
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
                color: HexColor(AppColor.colorOfToday),
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
      padding: EdgeInsets.fromLTRB(10, 35, 10, 0),
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
            onTap: (){
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
                  Text("Logout",
                      style: TextStyle(color: Colors.white)),
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

                      /// 👉 LOGOUT LOGIC HERE
                      final prefs = await SharedPreferences.getInstance();
                      print('Cleared All the storage data ');
                      await prefs.clear(); // 🔥 clear all saved data

                      if (!context.mounted) return;
                      // clear session / shared prefs
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(providers: [

                              BlocProvider(
                                create: (_) => InstructorRegBloc(),
                              ),

                              BlocProvider(
                                create: (_) => InstructorLoginBloc(),
                              ),

                              BlocProvider(
                                create: (_) => StudentLoginBloc(),
                              ),
                            ],
                                child: const LoginScreen(),
                            ),
                            //const LoginScreen()
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
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('assets/app_images/lady_driver.png'),

          Positioned(
            top: -100, // 👈 adjust this for perfect overlap
            left: 15,
            right: 15,
            child: _statsCard(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [

                SizedBox(height: 270),

                _subHeader("Lesson"),
                SizedBox(height: 10),
                _lessonList(),

                SizedBox(height: 25),

                _subHeader("Mocktest"),
                SizedBox(height: 10),

                lessons.isEmpty
                    ? emptyCard("Today has no mocktest") : ListView.separated(
                  shrinkWrap: true, // 🔥 IMPORTANT
                  physics: NeverScrollableScrollPhysics(), // 🔥 IMPORTANT
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (isMockLoading) {
                      return _mockShimmer(); // 👈 create this
                    } else {
                      return LessonCard(data: lessons[index]);
                    }
                  },
                ),
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
        "Today has no lesson",
      );
    }

    return SizedBox(
      height: 100, // 🔥 important for horizontal list
      child: lessonList.isEmpty
          ? emptyCard("Today has no lesson")
          : ListView.builder(
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


                /// DETAILS
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /*Row(
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
                      ),*/

                      Text(
                        "Topic: ${data.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),

                      Text(
                        "Date: ${data.classDate}",
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


  ///....................All My Shimmer Effect...............................///

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

  Widget _mockShimmer() {
    return Container(
      height: 110,
      //padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
      //color: Colors.white,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 190, height: 14, color: Colors.grey.shade400),
              ),

              SizedBox(height: 15,),
              // Second Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 120, height: 14, color: Colors.grey.shade400),
              ),

              SizedBox(height: 5,),
              // Third Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[100]!,
                child: Container(width: 210, height: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
          Spacer(),
          Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Container(width: 100, height: 30, color: Colors.grey.shade400),
          ),
        ],
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
                    text: 'Latest ',
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
          onTap: (){
            if(title=="Lesson") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MultiBlocProvider(providers: [
                    BlocProvider(
                      create: (_) => StudentLessonListBloc(),
                    ),
                  ],
                      child: LessonScreen(showBack: true,)
                  ),
                ),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MultiBlocProvider(providers: [
                        BlocProvider(
                          create: (_) =>
                              StudentMocktestListBloc(),
                        ),
                      ], child: MockTestScreen(showBack: true,)
                      ),
                ),
              );
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
              // decoration: BoxDecoration(
              //   color: Color.fromARGB(77, 158, 158, 158),
              //   borderRadius: BorderRadius.circular(10),
              // ),


              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 54, 113, 232),
                      Color.fromARGB(255, 3, 61, 175)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/app_icons/test_drive_steering.png',
                  //   width: 40,
                  //   color: HexColor(AppColor.colorOfAddStudent),
                  // ),
                  // SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( totalLesson as String,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'InterBold',
                            //color: HexColor(AppColor.colorOfAddStudent),
                            color: Colors.white
                        ),
                      ),
                      Text('Lesson', style: TextStyle(
                          color: Colors.white
                      ),),
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
              // decoration: BoxDecoration(
              //   color: Color.fromARGB(77, 158, 158, 158),
              //   borderRadius: BorderRadius.circular(10),
              // ),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 54, 113, 232),
                      Color.fromARGB(255, 3, 61, 175)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( totalMocktest,
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'InterBold',
                            //color: HexColor(AppColor.colorOfAddStudent),
                            color: Colors.white
                        ),
                      ),
                      Text('Mocktest', style: TextStyle(
                          color: Colors.white
                      ),),
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(width: 10),

          ///Download Training Report
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   color: Color.fromARGB(77, 158, 158, 158),
              //   borderRadius: BorderRadius.circular(10),
              // ),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 54, 113, 232),
                      Color.fromARGB(255, 3, 61, 175)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/app_icons/database_schema.png',
                  //   width: 30,
                  //   color: HexColor(AppColor.colorOfAddStudent),
                  // ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/app_icons/database_schema.png',
                        width: 30,
                        //color: HexColor(AppColor.colorOfAddStudent),
                        color: Colors.white,
                      ),
                      Text('Download \nTraining Report',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
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


  //Calling My fetch total Lesson count here
  Future<void> fetchTotalLessonCount() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
        prefs.getString("stud_user_id") ?? "";

    context.read<StudentTotalLessonCountBloc>()
        .add(FetchStudentTotalLessonCount(
        userId: userId,
      ),
    );
  }

  //Calling Fetch Total Mocktest Count

  Future<void> fetchTotalMocktestCount() async {

    final prefs =
    await SharedPreferences.getInstance();

    final userId =
        prefs.getString("stud_user_id") ?? "";

    context.read<StudentTotalMocktestCountBloc>().add(FetchStudentTotalMocktestCount(
        userId: userId,
      ),
    );
  }

  Future<void> fetchTodaysLessonList() async {

    final prefs =
    await SharedPreferences.getInstance();

    final studentCode =
        prefs.getString("stud_user_id") ?? "";

    context
        .read<StudentTodaysLessonListBloc>()
        .add(

      FetchStudentTodaysLessonList(

        studentCode: studentCode,
      ),
    );
  }

  Future<void> fetchTodaysMocktestList() async {

    final prefs =
    await SharedPreferences.getInstance();

    final studentCode =
        prefs.getString("stud_user_id") ?? "";

    context
        .read<StudentTodaysMocktestListBloc>()
        .add(

      FetchStudentTodaysMocktestList(

        studentCode: studentCode,
      ),
    );
  }

}

class LessonCard extends StatelessWidget {
  final StudentTodaysMocktestData data;

  const LessonCard({super.key, required this.data});
  //bool isMockLoading = true;

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // 🔥 light shadow
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4), // shadow down
          ),
        ],
      ),
      child: Column(
        children: [
          /// TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      data.name ?? 'No Lesson Found',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "InterBold",
                        color: HexColor("${AppColor.colourOfAdvanceCarDrive}"),
                      ),
                    ),

                    SizedBox(height: 6),

                    /// DURATION
                    Row(
                      children: [
                        Text(
                          "Lesson Duration: ",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "InterSemiBold",
                            color: HexColor(AppColor.colorAppGray),
                          ),
                        ),
                        Text(
                          data.duration.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "InterSemiBold",
                            color: HexColor("${AppColor.colorOfEditColour}"),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2),

                    /// DATE + TIME
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14,
                                color: HexColor(AppColor.colorAppGray)),
                            SizedBox(width: 2),
                            Text(
                              data.classDate ?? 'No Date',
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorOfEditColour),
                                fontFamily: "InterSemiBold",),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14,
                                color: HexColor(AppColor.colorAppGray)),
                            SizedBox(width: 2),
                            Text(
                              data.lessonStart ?? 'No Data',
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 12,color: HexColor(AppColor.colorOfEditColour),
                                fontFamily: "InterSemiBold",),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 5),

              /// RIGHT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  SizedBox(height: 30),

                  /// BUTTON
                  AppButton(
                    height: 34,
                    text: "Mock Test Report",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MockTestReportsScreen(),
                        ),
                      );

                    },
                    textStyle: TextStyle(
                      fontFamily: "InterBold",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

