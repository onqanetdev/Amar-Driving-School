

abstract class StudentDownloadTrainingReportEvent {}

class StudentDownloadTrainingReportTapped
    extends StudentDownloadTrainingReportEvent {

  final String loginId;

  StudentDownloadTrainingReportTapped({

    required this.loginId,
  });
}
