import 'package:flutter/material.dart';
import 'package:zatch_app/Widget/category_tabs_widget.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/model/login_response.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
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
  final List<Category>? selectedCategories; // Only used if coming from CategoryScreen

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
  final ApiService _apiService = ApiService();
  UserProfileResponse? userProfile;
  bool isLoading = true;
  String? error;

  bool _showAccountDetails = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) _showAccountDetails = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final profileModel = await _apiService.getUserProfile();
      setState(() {
        userProfile = profileModel;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        const SizedBox(height: 25),
        HeaderWidget(userProfile),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CategoryTabsWidget(
                  selectedCategories: widget.selectedCategories?.isNotEmpty == true
                      ? widget.selectedCategories // from CategoryScreen
                      : null, // Direct Home entry
                  onCategorySelected: (category) {
                    debugPrint("Selected Category: ${category.name}");
                  },
                ),
                LiveFollowersWidget(userProfile: userProfile),
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
