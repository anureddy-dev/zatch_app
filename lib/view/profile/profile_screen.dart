import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required Map<String, String> person});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final List<String> images = [
    "https://picsum.photos/id/1011/400/600",
    "https://picsum.photos/id/1012/400/400",
    "https://picsum.photos/id/1015/400/500",
    "https://picsum.photos/id/1016/400/600",
    "https://picsum.photos/id/1020/400/500",
    "https://picsum.photos/id/1021/400/500",
  ];

  final List<String> shopImages = [
    "https://picsum.photos/id/201/400/500",
    "https://picsum.photos/id/202/400/600",
    "https://picsum.photos/id/203/400/400",
  ];
  final List<String> liveImages = [
    "https://picsum.photos/id/301/400/400",
    "https://picsum.photos/id/302/500/500",
  ];

  late TabController _tabController;
  final List<String> _tabs = ["Buy Bits", "Shop", "Upcoming Live"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),backgroundColor:  Color(0xFF9CDD1F),),
      backgroundColor: const Color(0xFF9CDD1F),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              // Green background
              Container(
                height: 50,
                width: double.infinity,
                color: const Color(0xFF9CDD1F),
              ),

              // White rounded body
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 120), // space for profile overlap
                      _buildStats(),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 16),
                      _buildTabBar(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildGalleryView(images),
                            _buildShopView(),          
                            _buildLiveView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ✅ Overlayed profile section
          Positioned(
            top: 8, // sits between green & white
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=47"),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Ankitha Lauren",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.verified,
                        size: 18, color: Colors.lightBlueAccent),
                  ],
                ),
                const Text(
                  "215.1k Followers",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _StatItem(value: "4.9 ⭐", label: "Customer Rating"),
          _StatItem(value: "36.6k", label: "Reviews"),
          _StatItem(value: "360", label: "Products Sold"),
        ],
      ),
    );
  }

  // ✅ Chat, Follow, Share
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.chat_bubble_outline, color: Colors.black54),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9CDD1F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              elevation: 2,
            ),
            onPressed: () {},
            child: const Text("Follow",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.share, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ✅ Rounded TabBar
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ],
          ),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade700,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          unselectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        ),
      ),
    );
  }

  // ✅ Gallery View
  Widget _buildGalleryView(List<String> imageList) {
    if (imageList.isEmpty) {
      return const Center(
        child: Text(
          "No items to display yet!",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageList[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

Widget _buildShopView() {
  final products = [
    {"title": "Club Fleece Mens Jacket", "price": "₹ 56.97", "img": "https://picsum.photos/id/201/400/500"},
    {"title": "Skate Jacket", "price": "₹ 150.97", "img": "https://picsum.photos/id/202/400/500"},
    {"title": "Puffer Jacket", "price": "₹ 99.99", "img": "https://picsum.photos/id/203/400/500"},
  ];

  return GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
    ),
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(product["img"]!, fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product["title"]!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(product["price"]!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
Widget _buildLiveView() {
  final events = [
    {"date": "Tomorrow · 7:30PM", "title": "Nike Sneaker Collection", "img": "https://picsum.photos/id/301/500/500"},
    {"date": "7th July · 7:30PM", "title": "Nike Sneaker Collection", "img": "https://picsum.photos/id/302/500/500"},
  ];

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: events.length,
    itemBuilder: (context, index) {
      final event = events[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(event["img"]!, fit: BoxFit.cover, width: double.infinity, height: 200),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event["date"]!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(event["title"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text("Fashion", style: TextStyle(fontSize: 13, color: Colors.black54)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}


class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
