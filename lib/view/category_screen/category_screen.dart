import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/model/login_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/category_screen/simple_base_screen.dart';
import 'package:zatch_app/view/home_page.dart';

class CategoryScreen extends StatefulWidget {
  final LoginResponse? loginResponse;

  const CategoryScreen({
    super.key,
    this.loginResponse,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _apiService = ApiService();
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;

  // Track selected items
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final fetchedCategories = await _apiService.getCategories();
      final displayCategories = fetchedCategories
          .where((cat) => cat.name.toLowerCase() != 'explore all')
          .toList();

      setState(() {
        categories = displayCategories;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  Future<void> _saveCategoriesAndContinue() async {
    final selectedItems = selectedIndexes.map((i) => categories[i]).toList();

    // ✅ Save categories locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "userCategories",
      selectedItems.map((c) => c.name).toList(),
    );

    // ✅ Navigate to HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          loginResponse: widget.loginResponse,
          selectedCategories: selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenAlt(
      title: "Let’s find you\nSomething to shop for.",
      subtitle: "",
      contentWidgets: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (errorMessage != null)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(errorMessage ?? "Something went wrong"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: fetchCategories,
                  child: const Text("Retry"),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              final isSelected = selectedIndexes.contains(index);
              final imageUrl = item.iconUrl?.isNotEmpty == true
                  ? item.iconUrl!
                  : (item.image?.url ?? '');

              return InkWell(
                onTap: () => toggleSelection(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orangeAccent.withOpacity(0.3)
                        : const Color(0xFFF2F4F5),
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(color: Colors.orangeAccent, width: 2)
                        : null,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            );
                          },
                        )
                      else
                        const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
      bottomText: ElevatedButton(
        onPressed: selectedIndexes.isNotEmpty ? _saveCategoriesAndContinue : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor:
          selectedIndexes.isNotEmpty ? const Color(0xFFCCFF55) : Colors.grey,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
