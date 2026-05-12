

abstract class InstructorSubTopicListEvent {}

class FetchInstructorSubTopicList
    extends InstructorSubTopicListEvent {

  final String topicId;

  FetchInstructorSubTopicList({
    required this.topicId,
  });
}