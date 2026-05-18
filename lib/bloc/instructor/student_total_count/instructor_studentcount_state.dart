

import '../../../model/instructor_create_lesson_model/Instructor_student_total_count.dart';
abstract class InstructorStudentCountState {}

class InstructorStudentCountInitial
    extends InstructorStudentCountState {}

class InstructorStudentCountLoading
    extends InstructorStudentCountState {}

class InstructorStudentCountSuccess
    extends InstructorStudentCountState {

  final InstructorStudentTotalCountModel
  totalStudentResponse;

  InstructorStudentCountSuccess({

    required this.totalStudentResponse,
  });
}

class InstructorStudentCountFailure
    extends InstructorStudentCountState {

  final String error;

  InstructorStudentCountFailure(
      this.error,
      );
}