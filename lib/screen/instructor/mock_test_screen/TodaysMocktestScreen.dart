
import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_bloc.dart';
import 'package:amar_driving_school/bloc/instructor/todays_mocktest/instructor_todays_mocktest_state.dart';
import 'package:flutter/material.dart';
import '../../../bloc/instructor/todays_mocktest/instructor_todays_mocktest_event.dart';
import '../../../helper/helper.dart';
import '../../../helper/loader_helper.dart';
import '../../../model/instructor_todays_mocktest_model/instructor_todays_mocktest_model.dart';
import '../../../widgets/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Todaysmocktestscreen extends StatefulWidget {
  final bool showBack;
  const Todaysmocktestscreen({super.key, this.showBack = false});

  @override
  State<Todaysmocktestscreen> createState() => _TodaysmocktestscreenState();
}

class _TodaysmocktestscreenState extends State<Todaysmocktestscreen>  {
  final List<TodaysMocktestData> allMocktests = [

  ];

  //This Section is for Load more
  final ScrollController _scrollController = ScrollController();

  int offset = 0;

  int limit = 30;

  bool isLoadingMore = false;

  bool hasMore = true;



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

        /// MOCKTEST LIST
        BlocListener<
            InstructorTodaysMocktestBloc,
            InstructorTodaysMocktestState>(

          listener: (context, state) {

            /// LOADING
            if(state
            is InstructorTodaysMocktestLoading
                && offset == 0) {

              LoaderHelper.show(context);
            }

            /// SUCCESS
            if(state
            is InstructorTodaysMocktestSuccess) {

              LoaderHelper.hide(context);

              setState(() {

                if(offset == 0) {

                  allMocktests.clear();
                }

                allMocktests.addAll(

                  //state.mocktestListResponse.data,
                  state.todaysMocktestResponse.data
                );

                isLoadingMore = false;

                if(state
                    .todaysMocktestResponse
                    .data
                    .length < limit) {

                  hasMore = false;
                }
              });
            }

            /// FAILURE
            if(state
            is InstructorTodaysMocktestFailure) {

              LoaderHelper.hide(context);

              Helper.showToast(
                context,
                state.error,
              );
            }
          },
        ),

        /// DELETE MOCKTEST

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
                child: allMocktests.isEmpty
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
                    childAspectRatio: 0.8,
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
                            item.name,
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

    final userId = prefs.getString('user_id');

    offset = 0;
    hasMore = true;


    //bloc
    context.read<InstructorTodaysMocktestBloc>().add(

      FetchInstructorTodaysMocktest(

        instructorId: userId.toString(),

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

    final userId = prefs.getString('user_id');

    //bloc
    context.read<InstructorTodaysMocktestBloc>().add(

      FetchInstructorTodaysMocktest(

        instructorId: userId.toString(),

        //limit: limit.toString(),

        //offset: offset.toString(),
      ),
    );
  }

}
