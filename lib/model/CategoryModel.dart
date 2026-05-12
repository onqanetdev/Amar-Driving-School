import 'SubCategoryModel.dart';

class CategoryModel {
  final String name;
  final List<SubCategoryModel> subCategories; // NOT nullable

  CategoryModel({
    required this.name,
    required this.subCategories,
  });
}