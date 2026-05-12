class StudentModel {
  final String name;
  final String email;
  final String phone;
  final String duration;
  final String date;
  final double amount;
  final bool isPaid;

  StudentModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.duration,
    required this.date,
    required this.amount,
    this.isPaid = false,
  });
}