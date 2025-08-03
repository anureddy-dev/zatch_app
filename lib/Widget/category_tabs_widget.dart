import 'package:flutter/material.dart';

import '../controller/category_controller.dart';


class CategoryTabsWidget extends StatefulWidget {
  const CategoryTabsWidget({super.key});

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  final CategoryController _controller = CategoryController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),

      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _controller.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _controller.selectCategory(category.name);
                  });
                },
                style: ElevatedButton.styleFrom(

                  backgroundColor: category.isSelected
                      ? Colors.black
                      : Colors.grey[200],
                  foregroundColor: category.isSelected
                      ? Colors.white
                      : Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rectangular shape
                  ),

                ),
                child: Text(category.name),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}