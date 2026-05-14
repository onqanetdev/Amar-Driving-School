

class InstructorSubTopicListModel {

  final int status;
  final bool success;
  final String message;
  final List<SubTopicData> data;

  InstructorSubTopicListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorSubTopicListModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorSubTopicListModel(

      status: json['status'],
      success: json['success'],
      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => SubTopicData.fromJson(e),
      ).toList(),
    );
  }
}

class SubTopicData {

  final String id;
  final String name;
  final String slug;
  final String topicId;
  final String status;
  bool isSelected;

  SubTopicData({

    required this.id,
    required this.name,
    required this.slug,
    required this.topicId,
    required this.status,
    this.isSelected = false
  }
  );

  factory SubTopicData.fromJson(
      Map<String, dynamic> json) {

    return SubTopicData(

      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      topicId: json['topic_id'],
      status: json['status'],
    );
  }
}
