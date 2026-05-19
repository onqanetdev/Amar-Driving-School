
class InstructorAboutusModel {

  final int status;
  final bool success;
  final String message;
  final AboutUsData data;

  InstructorAboutusModel({

    required this.status,

    required this.success,

    required this.message,

    required this.data,
  });

  factory InstructorAboutusModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorAboutusModel(

      status: json['status'],

      success: json['success'],

      message: json['message'],

      data: AboutUsData.fromJson(
        json['data'],
      ),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data.toJson(),
    };
  }
}

class AboutUsData {

  final String id;
  final String pageTitle;
  final String pageSlug;
  final String pageDetails;
  final dynamic pageImage;
  final String pageStatus;
  final String createdAt;

  AboutUsData({

    required this.id,

    required this.pageTitle,

    required this.pageSlug,

    required this.pageDetails,

    required this.pageImage,

    required this.pageStatus,

    required this.createdAt,
  });

  factory AboutUsData.fromJson(
      Map<String, dynamic> json) {

    return AboutUsData(

      id: json['id'],

      pageTitle: json['page_title'],

      pageSlug: json['page_slug'],

      pageDetails: json['page_details'],

      pageImage: json['page_image'],

      pageStatus: json['page_status'],

      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'id': id,

      'page_title': pageTitle,

      'page_slug': pageSlug,

      'page_details': pageDetails,

      'page_image': pageImage,

      'page_status': pageStatus,

      'created_at': createdAt,
    };
  }
}