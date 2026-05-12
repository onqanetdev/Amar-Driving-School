

import 'package:amar_driving_school/ApiService/Instructor_Login_api_service.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_event.dart';
import 'package:amar_driving_school/bloc/instructor/login_instructor/instructor_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorLoginBloc extends Bloc<InstructorLoginEvent, InstructorLoginState> {
  InstructorLoginBloc (): super(InstructorLoginInitial()) {
    on<InstructorLoginTapped>(
        (event, emit) async {
          emit(InstructorLoginLoading());
          // try-catch
          try {
            final response = await InstructorLoginApiService().loginAhead(event.email, event.password);
            emit(InstructorLoginSuccess(responseInstructorLogin: response));
          } catch (e){
            emit(
              InstructorLoginFailure(e.toString())
            );
          }
        }
    );
  }
}