

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_state.dart';
import '../../../widgets/app_header.dart';

class CmsPageScreen extends StatelessWidget {

  final String title;

  const CmsPageScreen({

    super.key,

    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(

        children: [

          /// HEADER
          AppHeader(

            title: title,

            showBack: true,
          ),

          /// BODY
          Expanded(

            child: BlocBuilder<
                InstructorAboutUsBloc,
                InstructorAboutUsState>(

              builder: (context, state) {

                /// LOADING
                if(state
                is InstructorAboutUsLoading) {

                  return const Center(

                    child:
                    CircularProgressIndicator(),
                  );
                }

                /// SUCCESS
                if(state
                is InstructorAboutUsSuccess) {

                  final data =
                      state.aboutUsResponse.data;

                  return SingleChildScrollView(

                    padding:
                    const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        Text(

                          data.pageTitle,

                          style:
                          const TextStyle(

                            fontSize: 22,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Html(
                          data:
                          data.pageDetails,
                        ),
                      ],
                    ),
                  );
                }

                /// FAILURE
                if(state
                is InstructorAboutUsFailure) {

                  return Center(
                    child:
                    Text(state.error),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

