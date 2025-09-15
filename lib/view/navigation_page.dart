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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 0, selectedIndex == 0),
          _buildNavItem(Icons.bookmark_border, 1, selectedIndex == 1),
          const SizedBox(width: 40), // Space for center FAB
          _buildNavItem(Icons.settings_rounded, 2, selectedIndex == 2),
          _buildProfileItem(3, selectedIndex == 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Icon(
        icon,
        color: isSelected ? const Color(0xFFA3DD00) : Colors.grey,
        size: 33,
      ),
    );
  }

  Widget _buildProfileItem(int index, bool isSelected) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: isSelected ? Colors.green.withOpacity(0.2) : Colors.transparent,
        child: const CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"), // Example user avatar
        ),
      ),
    );
  }
}

class FloatingZButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingZButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72, // bigger button
      height: 72,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xFFD0FB52),
        elevation: 8,
        shape: const CircleBorder(),
        child: Image.asset(
          'assets/images/logo.png',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
