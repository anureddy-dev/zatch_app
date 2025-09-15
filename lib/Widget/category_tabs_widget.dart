import 'package:flutter/material.dart';
import '../controller/category_controller.dart';
import '../model/categories_response.dart';

class CategoryTabsWidget extends StatefulWidget {
  final Function(Category)? onCategorySelected;
  final List<Category>? selectedCategories; // preselected categories

  const CategoryTabsWidget({
    super.key,
    this.onCategorySelected,
    this.selectedCategories,
  });

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  final CategoryController _controller = CategoryController();
  List<Category> _orderedCategories = [];
  String? _selectedCategoryName; // track selected by name
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      await _controller.fetchCategories(); // fetch categories from API
      _orderCategories();

      // Set initial selected category
      if (widget.selectedCategories != null &&
          widget.selectedCategories!.isNotEmpty) {
        // Select the first preselected category
        _selectedCategoryName = widget.selectedCategories!.first.name;
      } else if (_orderedCategories.isNotEmpty) {
        // If no preselected, select the first category
        _selectedCategoryName = _orderedCategories.first.name;
      }

      // Trigger callback for initial selection
      final initialCategory = _orderedCategories.firstWhere(
              (c) => c.name == _selectedCategoryName,
          orElse: () => _orderedCategories.first);
      widget.onCategorySelected?.call(initialCategory);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _orderCategories() {
    final allCategories = _controller.categories ?? [];

    if (allCategories.isEmpty) return;

    if (widget.selectedCategories != null &&
        widget.selectedCategories!.isNotEmpty) {
      final selectedSet =
      widget.selectedCategories!.map((c) => c.name).toSet();

      final selectedFirst =
      allCategories.where((c) => selectedSet.contains(c.name)).toList();
      final remaining =
      allCategories.where((c) => !selectedSet.contains(c.name)).toList();

      _orderedCategories = [...selectedFirst, ...remaining];
    } else {
      _orderedCategories = allCategories;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text("Error: $_errorMessage"));
    }

    if (_orderedCategories.isEmpty) {
      return const Center(child: Text("No categories available"));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _orderedCategories.map((category) {
            final isSelected = category.name == _selectedCategoryName;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryName = category.name;
                  });
                  widget.onCategorySelected?.call(category);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
