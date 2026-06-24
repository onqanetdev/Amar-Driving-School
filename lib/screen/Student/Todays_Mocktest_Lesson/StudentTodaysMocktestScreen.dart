
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_bloc.dart';
import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_event.dart';
import '../../../bloc/student/todays_mocktest_list/student_todays_mocktest_list_state.dart';
import '../../../model/student_all_model/student_todays_lesson_mocktest_list_model.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Studenttodaysmocktestscreen extends StatefulWidget {
  final bool showBack;
  const Studenttodaysmocktestscreen({super.key, this.showBack = false});

  @override
  State<Studenttodaysmocktestscreen> createState() => _StudenttodaysmocktestscreenState();
}

class _StudenttodaysmocktestscreenState extends State<Studenttodaysmocktestscreen> {

   List<StudentTodaysMocktestData> allMocktests = [

  ];

  //This Section is for Load more
  final ScrollController _scrollController = ScrollController();

  int offset = 0;

  int limit = 30;

  bool isLoadingMore = false;

  bool hasMore = true;

  bool isMockLoading = true;

  @override
  void initState() {
    super.initState();

    fetchLessonList();

    //This Section is also for scrollView
    _scrollController.addListener(() {

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMore) {

        loadMoreLessons();
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    //bloc and state parameter
    return MultiBlocListener(

      listeners: [

        /// TODAY'S MOCKTEST LIST
        BlocListener<StudentTodaysMocktestListBloc, StudentTodaysMocktestListState>(

          listener: (context, state) {

            /// LOADING
            if(state is StudentTodaysMocktestListLoading) {

              //LoaderHelper.show(context);
              isMockLoading = true;
            }

            /// SUCCESS
            if(state is StudentTodaysMocktestListSuccess) {

              // LoaderHelper.hide(context);
              isMockLoading = false;
              setState(() {

                allMocktests = state.todaysMocktestListResponse
                    .data;
              });
            }

            /// FAILURE
            if(state is StudentTodaysMocktestListFailure) {
              //LoaderHelper.hide(context);
              isMockLoading = false;
              print(state.error);
            }
          },
        ),



      ],

      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          Navigator.pop(context, true);
        },

        child: Scaffold(
          backgroundColor: Color(0xFFE9E9E9),

          body: Column(
            children: [
              /// HEADER
              AppHeader(
                title: "Todays Mocktest",
                onBack: (){
                  Navigator.pop(context, true);
                },
                showBack: widget.showBack,
                showAddButton: false,
                //addButtonText: "Add Mocktest",
                onAdd: () {}

                ,
              ),
              SizedBox(height: 10,),
              /// LIST
              Expanded(
                child: isMockLoading
                    ? _mocktestShimmer()
                    : allMocktests.isEmpty
                    ? const Center(
                  child: Text(
                    "No Mocktest Found!",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "InterSemiBold",
                    ),
                  ),
                ) :

                GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: allMocktests.length,
                  itemBuilder: (context, index) {
                    final item = allMocktests[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 217, 217, 217),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/app_icons/user_black.png',
                              color: Color.fromARGB(255, 122, 122, 122),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }


  Future<void> fetchLessonList() async {

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('stud_user_id');

    offset = 0;
    hasMore = true;


    //bloc
    context.read<StudentTodaysMocktestListBloc>().add(

      FetchStudentTodaysMocktestList(

        studentCode: userId.toString(),

        //limit: limit.toString(),

        //offset: offset.toString(),
      ),
    );
  }

  Future<void> loadMoreLessons() async {

    if(isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    offset += 1;
    limit += 30;

    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('stud_user_id');

    //bloc
    context.read<StudentTodaysMocktestListBloc>().add(

      FetchStudentTodaysMocktestList(

         studentCode: userId!,

        //limit: limit.toString(),

        //offset: offset.toString(),
      ),
    );
  }

   Widget _mocktestShimmer() {
     return GridView.builder(
         padding: const EdgeInsets.symmetric(horizontal: 12),
         physics: const NeverScrollableScrollPhysics(),
         itemCount: 6,
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 3,
           crossAxisSpacing: 15,
           mainAxisSpacing: 20,
           childAspectRatio: 0.65,
         ),
         itemBuilder: (context, index) {
           return Shimmer.fromColors(
             baseColor: Colors.grey.shade300,
             highlightColor: Colors.grey.shade100,
             child: Container(
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(12),
                 ),
                 padding: const EdgeInsets.symmetric(
                   vertical: 12,
                   horizontal: 8,
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                   Container(
                   height: 60,
                   width: 60,
                   decoration: const BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                 ),

                 const SizedBox(height: 12),

             Container(
               height: 12,
               width: 70,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(4),
               ),
             ),

             const SizedBox(height: 8),

             Container(
               height: 12,
               width: 50,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(4),
               ),
             ),
             ],
           ),
           ),
           );
         },
     );
   }
}
