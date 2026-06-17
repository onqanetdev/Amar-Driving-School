

import '../../../model/student_all_model/student_download_file_model.dart';

abstract class StudentDownloadTrainingReportState {}

class StudentDownloadTrainingReportInitial
    extends StudentDownloadTrainingReportState {}

class StudentDownloadTrainingReportLoading
    extends StudentDownloadTrainingReportState {}

class StudentDownloadTrainingReportSuccess
    extends StudentDownloadTrainingReportState {

  final InstructorDownloadFileModel downloadTrainingReportResponse;

  StudentDownloadTrainingReportSuccess({

    required this.downloadTrainingReportResponse,
  });
}

class StudentDownloadTrainingReportFailure
    extends StudentDownloadTrainingReportState {

  final String error;

  StudentDownloadTrainingReportFailure(
      this.error,
      );
}