

abstract class StudentLoginEvent { }

class StudentLoggedInTapped extends StudentLoginEvent {
  final String loggedInId;
  StudentLoggedInTapped({
    required this.loggedInId
});
}