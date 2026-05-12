

import '../../../model/instructor_student_add/instructor_student_add.dart';

abstract class InstructorAddStudentState {}

class InstructorAddStudentInitial extends InstructorAddStudentState {}

class InstructorAddStudentLoading extends InstructorAddStudentState {}

class InstructorAddStudentSuccess extends InstructorAddStudentState {

  final InstructorStudentAddModel instructorStudentAddResponse;

  InstructorAddStudentSuccess({
    required this.instructorStudentAddResponse,
  });
}

class InstructorAddStudentFailure extends InstructorAddStudentState {

  final String error;

  InstructorAddStudentFailure(this.error);
}