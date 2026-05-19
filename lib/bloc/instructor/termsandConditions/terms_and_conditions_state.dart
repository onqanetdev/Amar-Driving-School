

import '../../../model/terms_and_Conditions_model.dart';

abstract class TermsConditionsState {}

class TermsConditionsInitial
    extends TermsConditionsState {}

class TermsConditionsLoading
    extends TermsConditionsState {}

class TermsConditionsSuccess
    extends TermsConditionsState {

  final InstructorTermsConditionsModel
  termsResponse;

  TermsConditionsSuccess({

    required this.termsResponse,
  });
}

class TermsConditionsFailure
    extends TermsConditionsState {

  final String error;

  TermsConditionsFailure(
      this.error,
      );
}