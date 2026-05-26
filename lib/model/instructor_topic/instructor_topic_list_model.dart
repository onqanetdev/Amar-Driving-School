

class InstructorTopicListModel {

  final int status;
  final bool success;
  final String message;
  final List<TopicData> data;

  InstructorTopicListModel({

    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory InstructorTopicListModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorTopicListModel(

      status: json['status'],
      success: json['success'],
      message: json['message'],

      data: (json['data'] as List)
          .map(
            (e) => TopicData.fromJson(e),
      ).toList(),
    );
  }
}


class TopicData {

  final String id;
  String name;
  final String slug;
  final String status;

  TopicData({

    required this.id,
    required this.name,
    required this.slug,
    required this.status,
  });

  factory TopicData.fromJson(
      Map<String, dynamic> json) {

    return TopicData(

      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      status: json['status'],
    );
  }
}