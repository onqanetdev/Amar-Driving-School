

class InstructorDownloadFileModel {

  final int status;
  final bool success;
  final String message;
  final DownloadFileData? data;

  InstructorDownloadFileModel({

    required this.status,
    required this.success,
    required this.message,
    this.data,
  });

  factory InstructorDownloadFileModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return InstructorDownloadFileModel(

      status: json['status'] ?? 0,

      success: json['success'] ?? false,

      message: json['message'] ?? '',

      data: json['data'] != null
          ? DownloadFileData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'data': data?.toJson(),
    };
  }
}



class DownloadFileData {

  final String filename;
  final String fileType;
  final String base64Data;
  final String path;

  DownloadFileData({

    required this.filename,
    required this.fileType,
    required this.base64Data,
    required this.path,
  });

  factory DownloadFileData.fromJson(
      Map<String, dynamic> json,
      ) {

    return DownloadFileData(

      filename: json['filename'] ?? '',

      fileType: json['file_type'] ?? '',

      base64Data: json['base64_data'] ?? '',

      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'filename': filename,

      'file_type': fileType,

      'base64_data': base64Data,

      'path': path,
    };
  }
}