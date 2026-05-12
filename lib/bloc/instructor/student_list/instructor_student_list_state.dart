

import '../../../model/instructor_student_list/instructor_student_list_model.dart';

abstract class InstructorStudentListState {}

class InstructorStudentListInitial
    extends InstructorStudentListState {}

class InstructorStudentListLoading
    extends InstructorStudentListState {}

class InstructorStudentListSuccess
    extends InstructorStudentListState {

  final InstructorStudentListModel studentListResponse;

  InstructorStudentListSuccess({
    required this.studentListResponse,
  });
}

class InstructorStudentListFailure
    extends InstructorStudentListState {

  final String error;

  InstructorStudentListFailure(
      this.error,
      );
}