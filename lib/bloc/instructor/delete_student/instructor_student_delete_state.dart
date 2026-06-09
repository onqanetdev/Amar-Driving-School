

import '../../../model/instructor_student_delete/instructor_student_delete.dart';

abstract class InstructorStudentDeleteState {}

class InstructorStudentDeleteInitial extends InstructorStudentDeleteState {}

class InstructorStudentDeleteLoading extends InstructorStudentDeleteState {}

class InstructorStudentDeleteSuccess extends InstructorStudentDeleteState {
  final InstructorStudentDeleteModel deleteResponse;
  InstructorStudentDeleteSuccess({
    required this.deleteResponse,
  });
}

class InstructorStudentDeleteFailure extends InstructorStudentDeleteState {
  final String error;
  InstructorStudentDeleteFailure(this.error);
}