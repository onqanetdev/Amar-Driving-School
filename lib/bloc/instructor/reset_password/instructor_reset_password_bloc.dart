

import 'package:amar_driving_school/bloc/instructor/reset_password/instructor_reset_password_event.dart';
import 'package:amar_driving_school/bloc/instructor/reset_password/instructor_reset_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_reset_password_api_service.dart';

class InstructorResetPasswordBloc extends Bloc<InstructorResetPasswordEvent, InstructorResetPasswordState> {

  InstructorResetPasswordBloc()
      : super(
    InstructorResetPasswordInitial(),
  ) {

    on<InstructorResetPasswordTapped>(
          (event, emit) async {

        emit(
          InstructorResetPasswordLoading(),
        );

        try {

          final response = await InstructorResetPasswordApiService()
              .resetPassword(

            userId: event.userId,
            otp: event.otp,
            newPassword: event.newPassword,
          );

          emit(
            InstructorResetPasswordSuccess(
              resetPasswordResponse: response,
            ),
          );

        } catch (e) {

          emit(
            InstructorResetPasswordFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}