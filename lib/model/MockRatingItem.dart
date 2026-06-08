class MockRatingItem {
  final String title;
  final String id;
  int selectedRating;
  bool isEditable;

  MockRatingItem({
    required this.title,
    required this.id,
    this.selectedRating = 0, // 🔥 default = 30%
    this.isEditable = false, // 🔒 locked initially
  });

  int get percentage {
    const list = [20, 30, 50, 80, 100];
    return selectedRating == 0 ? 0 : list[selectedRating - 1];
  }

  String get grade {
    switch (percentage) {
      case 100:
        return "A";
      case 80:
        return "B";
      case 50:
        return "C";
      case 30:
        return "D";
      default:
        return "E";
    }
  }
}