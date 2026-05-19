

abstract class TermsConditionsEvent {}

class FetchTermsConditions
    extends TermsConditionsEvent {

  final String pageTitle;

  FetchTermsConditions({

    required this.pageTitle,
  });
}