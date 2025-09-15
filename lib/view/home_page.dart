import 'package:flutter/material.dart';
import 'package:zatch_app/Widget/category_tabs_widget.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/model/login_response.dart';
import 'package:zatch_app/view/setting_view/account_setting_screen.dart';
import 'package:zatch_app/view/zatch_ai_screen.dart';
import '../Widget/Header.dart';
import '../Widget/bargain_picks_widget.dart';
import '../Widget/followers_widget.dart';
import '../Widget/live_followers_widget.dart';
import '../Widget/top_picks_this_week_widget.dart';
import '../Widget/trending.dart';
import 'navigation_page.dart';

class HomePage extends StatefulWidget {
  final LoginResponse? loginResponse;
  final List<Category>? selectedCategories;

  const HomePage({
    super.key,
    this.loginResponse,
    this.selectedCategories,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  bool _showAccountDetails = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) _showAccountDetails = false;
    });
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        const SizedBox(height: 25),
        HeaderWidget(widget.loginResponse),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CategoryTabsWidget(
                  selectedCategories: widget.selectedCategories ?? [],
                  onCategorySelected: (category) {
                    debugPrint("Selected Category: ${category.name}");
                  },
                ),

                LiveFollowersWidget(),
                const BargainPicksWidget(),
                const FollowersWidget(),
                const TopPicksThisWeekWidget(),
                const TrendingSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const Center(child: Text("Bookmarks")),
          const Center(child: Text("Settings")),
           AccountSettingsScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),

      floatingActionButton: FloatingZButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ZatchAiScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}
