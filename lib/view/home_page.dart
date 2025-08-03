import 'package:flutter/material.dart';
import '../Widget/Header.dart';
import '../Widget/bargain_picks_widget.dart';
import '../Widget/category_tabs_widget.dart';
import '../Widget/followers_widget.dart';
import '../Widget/live_followers_widget.dart';
import '../Widget/notification_cart.dart';
import '../Widget/top_picks_this_week_widget.dart';
import '../Widget/trending.dart';
import '../Widget/video_list_widget.dart';

import 'navigation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeTab() {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(), // Always visible
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    NotificationCartWidget(),
                    CategoryTabsWidget(),
                    LiveFollowersWidget(),
                    BargainPicksWidget(),
                    FollowersWidget(),
                    TopPicksThisWeekWidget(),
                    TrendingSection(),
                   // VideoListWidget(),
                    //ReelsVideoScreen(initialIndex: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const Center(child: Text('Explore', style: TextStyle(color: Colors.white))),
          const Center(child: Text('Orders', style: TextStyle(color: Colors.white))),
          const Center(child: Text('Profile', style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
