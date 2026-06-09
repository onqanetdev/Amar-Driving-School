

import '../../../model/instructor_student_update_model/instructor_student_update_model.dart';

abstract class InstructorStudentUpdateState {}

class InstructorStudentUpdateInitial
    extends InstructorStudentUpdateState {}

class InstructorStudentUpdateLoading
    extends InstructorStudentUpdateState {}

class InstructorStudentUpdateSuccess
    extends InstructorStudentUpdateState {

  final InstructorStudentUpdateModel updateResponse;

  InstructorStudentUpdateSuccess(this.updateResponse,);
}

class InstructorStudentUpdateFailure
    extends InstructorStudentUpdateState {

  final String error;

  InstructorStudentUpdateFailure(this.error,);
}