
import 'package:amar_driving_school/bloc/instructor/upload_training_report/instructor_upload_training_report_event.dart';
import 'package:amar_driving_school/bloc/instructor/upload_training_report/instructor_upload_training_report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_upload_training_api_service.dart';

class InstructorUploadTrainingReportBloc extends Bloc<InstructorUploadTrainingReportEvent, InstructorUploadTrainingReportState> {

  InstructorUploadTrainingReportBloc()
      : super(
    InstructorUploadTrainingReportInitial(),
  ) {

    on<UploadTrainingReport>(
          (event, emit) async {

        emit(
          InstructorUploadTrainingReportLoading(),
        );

        try {

          final response =
          await InstructorUploadTrainingReportApiService()
              .uploadTrainingReport(

            studentId:
            event.studentId,

            status:
            event.status,

            reportFile:
            event.reportFile,
          );

          emit(
            InstructorUploadTrainingReportSuccess(

              response:
              response,
            ),
          );

        } catch(e) {

          emit(
            InstructorUploadTrainingReportFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}