
import 'dart:io';

abstract class InstructorUploadTrainingReportEvent {}

class UploadTrainingReport
    extends InstructorUploadTrainingReportEvent {

  final String studentId;

  final String status;

  final File reportFile;

  UploadTrainingReport({

    required this.studentId,

    required this.status,

    required this.reportFile,
  });
}
