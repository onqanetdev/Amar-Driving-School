import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../bloc/instructor/about_us/instructor_about_us_bloc.dart';
import '../../../bloc/instructor/about_us/instructor_about_us_state.dart';
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

            BlocBuilder<InstructorAboutUsBloc, InstructorAboutUsState>(

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
                if(state is InstructorAboutUsSuccess) {

                  final data =
                      state.aboutUsResponse.data;

                  return SingleChildScrollView(

                    padding:
                    const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
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
            )


          ],
        ),
      ),
    );
  }
}