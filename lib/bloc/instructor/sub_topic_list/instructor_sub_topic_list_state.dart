
import '../../../model/instructor_topic/instructor_sub_topic_list_model.dart';

abstract class InstructorSubTopicListState {}

class InstructorSubTopicListInitial
    extends InstructorSubTopicListState {}

class InstructorSubTopicListLoading
    extends InstructorSubTopicListState {}

class InstructorSubTopicListSuccess
    extends InstructorSubTopicListState {

  final InstructorSubTopicListModel
  subTopicListResponse;

  InstructorSubTopicListSuccess({
    required this.subTopicListResponse,
  });
}

class InstructorSubTopicListFailure
    extends InstructorSubTopicListState {

  final String error;

  InstructorSubTopicListFailure(
      this.error,
      );
}