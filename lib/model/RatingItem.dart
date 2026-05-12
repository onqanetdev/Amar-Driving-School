class RatingItem {
  final String title;
  int selected;

  RatingItem({required this.title, this.selected = 0});
}

class RatingSection {
  final String title;
  final List<RatingItem> items;

  RatingSection({required this.title, required this.items});
}