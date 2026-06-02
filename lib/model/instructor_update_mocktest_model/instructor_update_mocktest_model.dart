
class InstructorUpdateMocktestModel {

  final int status;
  final bool success;
  final String message;

  InstructorUpdateMocktestModel({

    required this.status,
    required this.success,
    required this.message,
  });

  factory InstructorUpdateMocktestModel.fromJson(
      Map<String, dynamic> json) {

    return InstructorUpdateMocktestModel(

      status: json['status'] ?? 0,

      success: json['success'] ?? false,

      message: json['message'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "status": status,

      "success": success,

      "message": message,
    };
  }
}