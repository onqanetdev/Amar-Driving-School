

import '../../../model/instructor_contact_us_model/instructor_contact_us_form_model.dart';

abstract class InstructorContactUsState {}

class InstructorContactUsInitial
    extends InstructorContactUsState {}

class InstructorContactUsLoading
    extends InstructorContactUsState {}

class InstructorContactUsSuccess
    extends InstructorContactUsState {

  final InstructorContactUsFormModel contactUsResponse;

  InstructorContactUsSuccess({

    required this.contactUsResponse,
  });
}

class InstructorContactUsFailure
    extends InstructorContactUsState {

  final String error;

  InstructorContactUsFailure(
      this.error,
      );
}