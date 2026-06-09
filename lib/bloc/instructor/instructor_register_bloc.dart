

import 'package:amar_driving_school/ApiService/Instructor_Register_api_service.dart';
import 'package:amar_driving_school/bloc/instructor/instructor_register_event.dart';
import 'package:amar_driving_school/bloc/instructor/instructor_register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorRegBloc extends Bloc<InstructorRegisterEvent, InstructorRegisterState> {
  InstructorRegBloc() : super(InstructorRegisterInitial()) {
    on<InstructorRegTapped>((event, emit) async {
        emit(InstructorRegisterLoading());
        try {
          final response =
          await InstructorRegisterApiService()
              .registerAhead(
            event.name,
            event.email,
            event.phone,
            event.password,
          );
          /// Registration Successful
          if (response.success) {
            emit(
              InstructorRegisterSuccess(
                instructRegResponseData: response,
              ),
            );

          } else {
            /// API returned success = false
            emit(
              InstructorRegisterFailure(
                response.message,
              ),
            );
          }

        } catch (e) {
          emit(
            InstructorRegisterFailure(
              e.toString(),
            ),
          );
        }
      },
    );
  }
}