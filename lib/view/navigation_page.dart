import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Bottom Navigation Bar Background
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(context: context, icon: Icons.home, index: 0),
                _buildNavItem(context: context, icon: Icons.explore, index: 1),
                const SizedBox(width: 60), // space for Z button
                _buildNavItem(context: context, icon: Icons.local_shipping_outlined, index: 2),
                _buildProfileIcon(context: context, index: 3),
              ],
            ),
          ),

          // Center Floating Z Button
          Positioned(
            bottom: 30, // Raised high enough above gesture bar
            child: GestureDetector(
              onTap: () {
                // Optional central Z action
              },
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/vector.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation item builder
  Widget _buildNavItem({required BuildContext context, required IconData icon, required int index}) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
      ),
    );
  }

  // Profile image item builder
  Widget _buildProfileIcon({required BuildContext context, required int index}) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
              : null,
        ),
        child: const CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage('assets/images/img1.png'),
        ),
      ),
    );
  }
}
