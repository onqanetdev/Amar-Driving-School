


import 'package:amar_driving_school/ApiService/Student_Api_service/Student_login_Api_service.dart';
import 'package:amar_driving_school/bloc/student/student_login/student_login_event.dart';
import 'package:amar_driving_school/bloc/student/student_login/student_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLoginBloc extends Bloc<StudentLoginEvent, StudentLoginState> {
  StudentLoginBloc (): super(StudentLoginInitial()) {
    on<StudentLoggedInTapped>(
        (event, emit) async {
          emit(StudentLoginLoading());
          try {
            final response = await StudentLoginApiService().loginAhead(event.loggedInId);
            emit(StudentLoginSuccess(studResdata: response));
          } catch (e) {
            emit(
                StudentLoginFailure(e.toString())
            );
          }
        }
    );
  }
}