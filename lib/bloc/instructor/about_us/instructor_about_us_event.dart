
abstract class InstructorAboutUsEvent {}

class FetchInstructorAboutUs
    extends InstructorAboutUsEvent {

  final String pageTitle;

  FetchInstructorAboutUs({

    required this.pageTitle,
  });
}