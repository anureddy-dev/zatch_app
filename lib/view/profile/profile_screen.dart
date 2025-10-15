import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/model/user_profile_model.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/zatching_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Buy Bits", "Shop", "Upcoming Live"];

  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isFollowing = false;
  bool _isSharing = false;
  bool _isFollowLoading = false;
   late Zatch zatch;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchUserProfile();
  }
  void _showMessage(String title, String message, {bool isError = false}) {
    if (!mounted) return;
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? Colors.red : Colors.green,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  Future<void> _fetchUserProfile() async {
    if (widget.userId == null) {
      debugPrint("⚠️ No userId provided for ProfileScreen");
      setState(() => _isLoading = false);
      return;
    }
    debugPrint("❌ Error fetching profile: ${widget.userId!}");

    try {
      final profile = await ApiService().getUserProfileById(widget.userId!);
      setState(() {
        _userProfile = profile;
        _isFollowing = profile.followers.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onFollowPressed() async {
    if (widget.userId == null) return;
    setState(() => _isFollowLoading = true);

    try {
      final res = await ApiService().toggleFollowUser(widget.userId!);

      setState(() {
        _isFollowing = !_isFollowing;
        _isFollowLoading = false;
      });

      final message = _isFollowing
          ? "You are now following ${_userProfile?.username ?? 'this user'}"
          : "You unfollowed ${_userProfile?.username ?? 'this user'}";
      _showMessage(_isFollowing ? "Followed" : "Unfollowed", message);

    } catch (e) {
      setState(() => _isFollowLoading = false);
    }
  }


  Future<void> _onSharePressed() async {
    if (widget.userId == null) return;
    setState(() => _isSharing = true);

    try {
      final res = await ApiService().shareUserProfile(widget.userId!);
      setState(() => _isSharing = false);

      if (res.profileData != null) {
        await Share.share("Check out this Zatch profile: ${res.profileData}");
      } else {
        _showMessage("Share Failed", "No share link available.", isError: true);
      }
    } catch (e) {
      setState(() => _isSharing = false);
    }
  }

  /*void _onMessagePressed() {
    _showMessage("Coming Soon", "The message feature is not available yet.");
  }*/

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9CDD1F),
      ),
      backgroundColor: const Color(0xFF9CDD1F),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _userProfile == null
          ? const Center(child: Text("User not found"))
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    final user = _userProfile!;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(height: 50, color: const Color(0xFF9CDD1F)),
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
                    const SizedBox(height: 120),
                    _buildStats(user),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                    _buildTabBar(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGalleryView(user),
                          _buildShopView(user),
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
        _buildProfileHeader(user),
      ],
    );
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Positioned(
      top: 8,
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
            child: CircleAvatar(
              radius: 50,
              backgroundImage: user.profilePicUrl != null
                  ? NetworkImage(user.profilePicUrl!)
                  : const NetworkImage("https://via.placeholder.com/150"),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.username ?? "Unnamed User",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.verified,
                  size: 18, color: Colors.lightBlueAccent),
            ],
          ),
          Text(
            "${user.followerCount} Followers",
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(UserProfile user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: "${user.customerRating} ⭐", label: "Customer Rating"),
          _StatItem(value: "${user.reviewsCount}", label: "Reviews"),
          _StatItem(value: "${user.productsSoldCount}", label: "Products Sold"),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.black54),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ZatchingDetailsScreen(zatch: zatch),
                  ),
                );              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              _isFollowing ? Colors.grey.shade300 : const Color(0xFF9CDD1F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              elevation: 2,
            ),
            onPressed: _isFollowLoading ? null : _onFollowPressed,
            child: _isFollowLoading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              _isFollowing ? "Following" : "Follow",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              icon: _isSharing
                  ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.share, color: Colors.black54),
              onPressed: _isSharing ? null : _onSharePressed,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildGalleryView(UserProfile user) {
    final gallery = user.sellingProducts
        .map<String>((e) => e['image']?['url'] ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    if (gallery.isEmpty) {
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
        itemCount: gallery.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(gallery[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildShopView(UserProfile user) {
    final products = user.sellingProducts;

    if (products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

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
        final img = product['image']?['url'] ?? '';
        final title = product['name'] ?? 'Unnamed';
        final price = product['price']?.toString() ?? '';

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
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(price,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiveView() {
    return const Center(child: Text("No live events available yet"));
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
