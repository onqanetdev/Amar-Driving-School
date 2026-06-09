

import 'package:amar_driving_school/bloc/instructor/update_student_information/instructor_student_update_event.dart';
import 'package:amar_driving_school/bloc/instructor/update_student_information/instructor_student_update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ApiService/instructor_student_update_api_service.dart';

class InstructorStudentUpdateBloc extends Bloc<InstructorStudentUpdateEvent, InstructorStudentUpdateState> {

  InstructorStudentUpdateBloc() : super(InstructorStudentUpdateInitial(),) {
    on<SubmitInstructorStudentUpdate>((event, emit,) async {

      emit(InstructorStudentUpdateLoading(),);

      try {

        final response = await InstructorStudentUpdateApiService.updateStudent(

          userId: event.userId,
          name: event.name,
          age: event.age,
          startDate: event.startDate,
          phone: event.phone,
          duration: event.duration,
          price: event.price,
          paymentStatus: event.paymentStatus,
        );

        emit(
          InstructorStudentUpdateSuccess(
            response,
          ),
        );

      } catch (e) {

        emit(
          InstructorStudentUpdateFailure(
            e.toString(),
          ),
        );
      }
    });
  }
}