import 'package:flutter/material.dart';
import 'package:zatch_app/Widget/category_tabs_widget.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/model/login_response.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/sellersscreens/SellHomeScreen.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/search_view/search_screen.dart';
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

  const HomePage({super.key, this.loginResponse, this.selectedCategories});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();
  UserProfileResponse? userProfile;
  List<Category> _allCategories = [];
  bool isLoading = true;
  String? error;

  // This state is no longer needed here if AccountSettingsScreen manages its own state
  // bool _showAccountDetails = false;
  Category? _selectedCategory;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // The logic for _showAccountDetails is removed as it's better handled within AccountSettingsScreen
    });
  }
  void _openZatchAi() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be taller than half the screen
      backgroundColor: Colors.transparent, // Makes container's rounded corners visible
      builder: (context) => const ZatchAiScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _apiService.init().then((_) {
        fetchUserProfile();
        _fetchAllCategories();
      });
    }
  }
  Future<void> _fetchAllCategories() async {
    try {
      final fetched = await _apiService.getCategories();
      if (mounted) {
        setState(() {
          final exploreAllCategory = Category(
            id: "0",
            easyname: 'Explore All', name: 'Explore All', subCategories: [],
          );
          _allCategories = [exploreAllCategory, ...fetched];
          _selectedCategory = _allCategories.first;
        });
      }
    } catch (e) {
      print("Failed to fetch all categories: $e");
    }
  }

  Future<void> fetchUserProfile() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final profileModel = await _apiService.getUserProfile();
      if (mounted) {
        setState(() {
          userProfile = profileModel;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  Widget _buildContentForCategory() {
   if (_selectedCategory == null || _selectedCategory!.name.toLowerCase() == 'explore all') {
      return Column(
        children: [
          const LiveFollowersWidget(),
          const BargainPicksWidget(),
          const FollowersWidget(),
          const TopPicksThisWeekWidget(),
          const TrendingSection(),
          const SizedBox(height: 40),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Content for ${_selectedCategory!.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Implement your category-specific widgets here.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFA3DD00)),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error ?? "Something went wrong"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchUserProfile,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 25),
        HeaderWidget(userProfile, onSearchTap: () => _onItemTapped(1)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CategoryTabsWidget(
                  selectedCategories:
    _allCategories,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    debugPrint("Selected Category: ${category.name}");
                  },
                ),
                _buildContentForCategory(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SearchScreen(key: UniqueKey(), userProfile: userProfile),
      SellHomeScreen(),
      AccountSettingsScreen(),
    ];

    return  WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
          userProfile: userProfile,
        ),
        floatingActionButton: FloatingZButton(
            onPressed: _openZatchAi,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A simple placeholder for the messages screen
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Messages Yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
