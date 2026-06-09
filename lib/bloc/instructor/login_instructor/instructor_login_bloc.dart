

import 'package:amar_driving_school/ApiService/Instructor_Login_api_service.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_event.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorLoginBloc extends Bloc<InstructorLoginEvent, InstructorLoginState> {

  InstructorLoginBloc() : super(InstructorLoginInitial()) {

    on<InstructorLoginTapped>((event, emit) async {
        emit(InstructorLoginLoading());
        try {
          final response =
          await InstructorLoginApiService()
              .loginAhead(
            event.email,
            event.password,
          );
          /// SUCCESS LOGIN
          if (response.success) {

            emit(
              InstructorLoginSuccess(
                responseInstructorLogin:
                response,
              ),
            );
          } else {
            /// INVALID EMAIL/PASSWORD
            emit(
              InstructorLoginFailure(
                response.message,
              ),
            );
          }

        } catch (e) {
          emit(
            InstructorLoginFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}