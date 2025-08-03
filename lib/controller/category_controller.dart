

import '../model/category_model.dart';

class CategoryController {
  List<Category> categories = [
    Category('Explore all', isSelected: true),
    Category('Fashion'),
    Category('Technology'),
    Category('Sneakers'),
    Category('Watches'),
  ];

  void selectCategory(String categoryName) {
    for (var category in categories) {
      category.isSelected = category.name == categoryName;
    }
  }
}