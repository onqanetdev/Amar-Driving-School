

import '../../../model/profile_extras/instructor_about_us_model.dart';

abstract class InstructorAboutUsState {}

class InstructorAboutUsInitial
    extends InstructorAboutUsState {}

class InstructorAboutUsLoading
    extends InstructorAboutUsState {}

class InstructorAboutUsSuccess
    extends InstructorAboutUsState {

  final InstructorAboutusModel aboutUsResponse;

  InstructorAboutUsSuccess({

    required this.aboutUsResponse,
  });
}

class InstructorAboutUsFailure
    extends InstructorAboutUsState {

  final String error;

  InstructorAboutUsFailure(
      this.error,
      );
}