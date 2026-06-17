

class InvoiceModel {
  final int status;
  final bool success;
  final String message;
  final String path;

  InvoiceModel({

    required this.status,
    required this.success,
    required this.message,
    required this.path,
  });

  factory InvoiceModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return InvoiceModel(

      status: json['status'] ?? 0,

      success: json['success'] ?? false,

      message: json['message'] ?? '',

      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'status': status,

      'success': success,

      'message': message,

      'path': path,
    };
  }
}