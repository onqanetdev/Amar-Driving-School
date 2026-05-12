

import '../../../model/instructor_topic/instructor_topic_list_model.dart';

abstract class InstructorTopicListState {}

class InstructorTopicListInitial extends InstructorTopicListState {}

class InstructorTopicListLoading extends InstructorTopicListState {}

class InstructorTopicListSuccess extends InstructorTopicListState {

  final InstructorTopicListModel topicListResponse;

  InstructorTopicListSuccess({
    required this.topicListResponse,
  });
}

class InstructorTopicListFailure
    extends InstructorTopicListState {

  final String error;

  InstructorTopicListFailure(
      this.error,
      );
}