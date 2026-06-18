

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/Instructor_Add_Student_Api_Service.dart';
import 'instructor_add_student_event.dart';
import 'instructor_add_student_state.dart';

class InstructorAddStudentBloc extends Bloc<InstructorAddStudentEvent, InstructorAddStudentState> {

  InstructorAddStudentBloc() : super(InstructorAddStudentInitial()) {

    on<InstructorAddStudentTapped>(
          (event, emit) async {

        emit(InstructorAddStudentLoading());

        try {

          final response =
          await InstructorAddStudentApiService().addedStudent(
            name: event.name,
            age: event.age,
            startdate: event.startdate,
            email: event.email,
            duration: event.duration,
            price: event.price,
            instructureid: event.instructureid,
            paymentstatus: event.paymentstatus,
            phone: event.phone,

          );

          emit(
            InstructorAddStudentSuccess(
              instructorStudentAddResponse:
              response,
            ),
          );

        } catch(e) {
          emit(
            InstructorAddStudentFailure(
              e.toString().replaceFirst('Exception: ', ''),
            ),
          );
        }
      },
    );
  }
}