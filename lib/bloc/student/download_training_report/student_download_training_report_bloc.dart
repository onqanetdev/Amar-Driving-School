


import 'package:amar_driving_school/bloc/student/download_training_report/student_download_training_report_event.dart';
import 'package:amar_driving_school/bloc/student/download_training_report/student_download_training_report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Student_Api_service/student_download_training_report_api_service.dart';

class StudentDownloadTrainingReportBloc extends Bloc<StudentDownloadTrainingReportEvent, StudentDownloadTrainingReportState> {

  StudentDownloadTrainingReportBloc()
      : super(
    StudentDownloadTrainingReportInitial(),
  ) {

    on<StudentDownloadTrainingReportTapped>(
          (event, emit) async {

        emit(
          StudentDownloadTrainingReportLoading(),
        );

        try {

          final response = await StudentDownloadTrainingReportApiService()
              .downloadTrainingReport(
            loginId: event.loginId,
          );

          emit(
            StudentDownloadTrainingReportSuccess(
              downloadTrainingReportResponse: response,
            ),
          );

        } catch(e) {

          emit(
            StudentDownloadTrainingReportFailure(
              e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
            ),
          );
        }
      },
    );
  }
}