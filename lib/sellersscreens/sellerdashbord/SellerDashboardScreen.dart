import 'package:flutter/material.dart';

// Main Screen Widget - Now a clean Scaffold
class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCF656),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCCF656),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFDFDEDE)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
            ),
          ),
        ),
        title: const Text(
          'Seller Dashboard',
          style: TextStyle(
            color: Color(0xFF121111),
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // TODO: Handle notification tap
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          // The white rounded container for the main content
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Welcome Header
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Color(0xFF101727),
                    fontSize: 20.51,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Here's how your store is performing",
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Seller Profile Card
                const SellerProfileCard(
                  storeName: 'Fashion Forward',
                  avatarUrl: 'https://placehold.co/49x49',
                  rating: '4.8',
                  isVerified: true,
                ),
                const SizedBox(height: 21),

                // 3. Awaiting Orders Card
                const AwaitingOrdersCard(orderCount: 2),
                const SizedBox(height: 21),

                // 4. Stats Grid
                const StatsGrid(),
                const SizedBox(height: 21),

                // 5. Setup Progress Card (Conditional)
                const SetupProgressCard(
                  completedTasks: ['Upload first product', 'Add product images (min 3)'],
                  allTasks: [
                    'Upload first product',
                    'Add product images (min 3)',
                    'Set auto-accept bargain %',
                    'Upload first reel',
                    'Verify bank details',
                    'Accept seller terms',
                  ],
                ),
                const SizedBox(height: 30),

                // 6. Quick Actions Section
                const SectionHeader(title: 'Quick Actions'),
                const QuickActionCard(
                  title: 'Go Live',
                  subtitle: 'Start live selling',
                  icon: Icons.sensors,
                  iconColor: Color(0xFF101828),
                  backgroundColor: Color(0xFFA2DC00),
                ),
                const QuickActionCard(
                  title: 'Upload Reel',
                  subtitle: 'Upload reels and tag products to them',
                  icon: Icons.movie_creation_outlined,
                  iconColor: Color(0xFF101828),
                  backgroundColor: Color(0xFFA2DC00),
                ),
                const QuickActionCard(
                  title: 'Orders',
                  subtitle: '2 pending',
                  icon: Icons.shopping_bag_outlined,
                  iconColor: Colors.white,
                  backgroundColor: Color(0xFF101727),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 30),

                // 7. Manage Store Section
                const SectionHeader(title: 'Manage Store'),
                const ManageStoreCard(
                  title: 'Edit Profile',
                  icon: Icons.person_outline,
                ),
                const ManageStoreCard(
                  title: 'Manage Products',
                  icon: Icons.inventory_2_outlined,
                  productCount: 13,
                ),
                const ManageStoreCard(
                  title: 'Payments',
                  icon: Icons.currency_rupee,
                ),
              ],
            ),
          ),
        ),
      ),
      // TODO: Implement the custom bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFFA2DC00),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }
}


// --- Reusable Child Widgets ---

// Header for a section like "Quick Actions" or "Manage Store"
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 14.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF101727),
          fontSize: 15.43,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Card for showing seller profile info
class SellerProfileCard extends StatelessWidget {
  final String storeName;
  final String avatarUrl;
  final String rating;
  final bool isVerified;

  const SellerProfileCard({
    super.key,
    required this.storeName,
    required this.avatarUrl,
    required this.rating,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.75)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.5,
              backgroundColor: const Color(0xFFF2F4F6),
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      color: Color(0xFF101727),
                      fontSize: 15.55,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFFF86),
                            borderRadius: BorderRadius.circular(6.75),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check, color: Color(0xFF008235), size: 12),
                              SizedBox(width: 3.5),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: Color(0xFF008235),
                                  fontSize: 9.68,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3.5),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Color(0xFF354152),
                          fontSize: 11.53,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card for showing pending orders
class AwaitingOrdersCard extends StatelessWidget {
  final int orderCount;
  const AwaitingOrdersCard({super.key, required this.orderCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFFFFF7ED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.75)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Color(0xFFF9DDB8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF7E2A0B), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$orderCount Orders Awaiting',
                    style: const TextStyle(
                      color: Color(0xFF7E2A0B),
                      fontSize: 13.56,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Process orders to maintain seller rating',
                    style: TextStyle(
                      color: Color(0xFFC93400),
                      fontSize: 11.34,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The 2x2 grid for stats like Revenue, Orders, etc.
class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        StatCard(
          title: 'Monthly Revenue',
          value: '₹24,580',
          change: '+12%',
          icon: Icons.currency_rupee,
        ),
        StatCard(
          title: 'Total Orders',
          value: '145',
          change: '+8 this week',
          icon: Icons.shopping_cart_checkout,
        ),
        StatCard(
          title: 'Product Views',
          value: '1.2K',
          change: '+18% this week',
          icon: Icons.visibility_outlined,
        ),
        StatCard(
          title: 'Conversion Rate',
          value: '3.4%',
          change: '+0.2% this week',
          icon: Icons.trending_up,
        ),
      ],
    );
  }
}

// Individual card used within the StatsGrid
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.75)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0x4CCCF656),
                borderRadius: BorderRadius.circular(8.75),
              ),
              child: Icon(icon, color: const Color(0xFF4A5565), size: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF101727),
                    fontSize: 18.05,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF697282),
                    fontSize: 9.84,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                Text(
                  change,
                  style: const TextStyle(
                    color: Color(0xFF00A63D),
                    fontSize: 10.50,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Card for "Quick Actions"
class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.75)),
      margin: const EdgeInsets.only(bottom: 10.50),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.75),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Opacity(
                    opacity: 0.9,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11.34,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card for "Manage Store" options
class ManageStoreCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? productCount;

  const ManageStoreCard({
    super.key,
    required this.title,
    required this.icon,
    this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color(0xFFF9FAFB),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFF2F4F6)),
        borderRadius: BorderRadius.circular(12.75),
      ),
      margin: const EdgeInsets.only(bottom: 7),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF9C9),
                borderRadius: BorderRadius.circular(8.75),
              ),
              child: Icon(icon, color: const Color(0xFF4A5565), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF101727),
                  fontSize: 13.12,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
            if (productCount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA2DC00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  productCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Card for showing setup progress
class SetupProgressCard extends StatelessWidget {
  final List<String> allTasks;
  final List<String> completedTasks;

  const SetupProgressCard({
    super.key,
    required this.allTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = completedTasks.length / allTasks.length;

    return Card(
      elevation: 2,
      color: const Color(0xFFF8FAFB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.75)),
      child: Padding(
        padding: const EdgeInsets.all(17.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete Your Seller Setup',
              style: TextStyle(
                color: Color(0xFF101727),
                fontSize: 15.31,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: const Color(0xFFA2DC00),
                      minHeight: 7,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFF495565),
                    fontSize: 12.30,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'More complete profiles sell 3x faster',
              style: TextStyle(
                color: Color(0xFF697282),
                fontSize: 9.68,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 21),
            // Dynamically build the list of tasks
            ...allTasks.map((task) {
              final bool isCompleted = completedTasks.contains(task);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isCompleted ? const Color(0xFFA2DC00) : Colors.grey[300],
                      size: 21,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      task,
                      style: TextStyle(
                        color: const Color(0xFF101727),
                        fontSize: 11.34,
                        fontFamily: 'Inter',
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 21),
            // The button at the bottom
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the next setup step
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA2DC00),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.75)),
              ),
              child: const Text(
                'Set auto-accept bargain', // This can be made dynamic
                style: TextStyle(
                  color: Color(0xFF101727),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
