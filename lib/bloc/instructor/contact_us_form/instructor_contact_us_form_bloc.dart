

import 'package:amar_driving_school/bloc/instructor/contact_us_form/contact_us_form_event.dart';
import 'package:amar_driving_school/bloc/instructor/contact_us_form/instructor_contact_us_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_contact_us_api_service.dart';

class InstructorContactUsBloc extends Bloc<InstructorContactUsEvent, InstructorContactUsState> {

  InstructorContactUsBloc() : super(InstructorContactUsInitial(),) {

    on<SubmitInstructorContactUs>(
          (event, emit) async {

        emit(
          InstructorContactUsLoading(),
        );

        try {

          final response =
          await InstructorContactUsApiService().submitContactForm(
            firstName:
            event.firstName,

            lastName:
            event.lastName,

            email:
            event.email,

            contact:
            event.contact,

            message:
            event.message,
          );

          emit(InstructorContactUsSuccess(

              contactUsResponse:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorContactUsFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}