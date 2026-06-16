

import 'package:amar_driving_school/bloc/instructor/forget_password/instructor_forget_password_event.dart';
import 'package:amar_driving_school/bloc/instructor/forget_password/instructor_forget_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_forget_password_api_service.dart';

class InstructorForgotPasswordBloc extends Bloc<
    InstructorForgotPasswordEvent,
    InstructorForgotPasswordState> {

  InstructorForgotPasswordBloc()
      : super(
    InstructorForgotPasswordInitial(),
  ) {

    on<InstructorForgotPasswordTapped>(
          (event, emit) async {

        emit(
          InstructorForgotPasswordLoading(),
        );

        try {

          final response =
          await InstructorForgotPasswordApiService()
              .forgotPassword(

            email: event.email,
          );

          emit(
            InstructorForgotPasswordSuccess(
              forgotPasswordResponse: response,
            ),
          );

        }
        catch (e) {

          emit(
            InstructorForgotPasswordFailure(
              e.toString().replaceFirst('Exception: ', ''),
            ),
          );
        }
      },
    );
  }
}