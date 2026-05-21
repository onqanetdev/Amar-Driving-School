
import '../../../model/instructor_upload_training_report/instructor_upload_training_report.dart';

abstract class InstructorUploadTrainingReportState {}

class InstructorUploadTrainingReportInitial
    extends InstructorUploadTrainingReportState {}

class InstructorUploadTrainingReportLoading
    extends InstructorUploadTrainingReportState {}

class InstructorUploadTrainingReportSuccess
    extends InstructorUploadTrainingReportState {

  final InstructorUploadTrainingReport response;

  InstructorUploadTrainingReportSuccess({

    required this.response,
  });
}

class InstructorUploadTrainingReportFailure
    extends InstructorUploadTrainingReportState {

  final String error;

  InstructorUploadTrainingReportFailure(
      this.error,
      );
}