

import 'package:amar_driving_school/bloc/instructor/about_us/instructor_about_us_event.dart';
import 'package:amar_driving_school/bloc/instructor/about_us/instructor_about_us_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_about_us_Api_Service.dart';

class InstructorAboutUsBloc extends Bloc<InstructorAboutUsEvent, InstructorAboutUsState> {

  InstructorAboutUsBloc() : super(InstructorAboutUsInitial(),) {

    on<FetchInstructorAboutUs>(
          (event, emit) async {

        emit(
          InstructorAboutUsLoading(),
        );

        try {

          final response =
          await InstructorAboutUsApiService()
              .fetchAboutUs(

            pageTitle:
            event.pageTitle,
          );

          emit(
            InstructorAboutUsSuccess(

              aboutUsResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorAboutUsFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}