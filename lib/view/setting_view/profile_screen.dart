import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zatch_app/model/user_profile_response.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfileResponse? userProfile;

  const ProfileScreen(this.userProfile, {super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userProfile?.user;

    final name = user?.username?.isNotEmpty == true ? user!.username : "Unknown User";
    final followers = user?.followerCount ?? 0;
    final profilePicUrl = (user?.profilePic.url?.isNotEmpty == true)
        ? user!.profilePic.url
        : "https://via.placeholder.com/150"; // fallback avatar

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9CDD1F),
      ),
      backgroundColor: const Color(0xFF9CDD1F),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(height: 50, width: double.infinity, color: const Color(0xFF9CDD1F)),

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
                      const SizedBox(height: 60),

                      // ✅ Name
                      Text(
                        name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),

                      // ✅ Followers
                      Text(
                        "$followers Sellers Following",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // ✅ Tabs
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.all(4),
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 2,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                          tabs: const [
                            Tab(text: "Saved Bits"),
                            Tab(text: "Saved Products"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ✅ Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            buildGallery(
                              (user?.savedBits ?? [])
                                  .map((e) => e is Map<String, dynamic> ? e['url'].toString() : e.toString())
                                  .toList(),
                            ),
                            buildGallery(
                              (user?.savedProducts ?? [])
                                  .map((e) => e is Map<String, dynamic> ? e['url'].toString() : e.toString())
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ✅ Avatar
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePicUrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGallery(List<String> imageList) {
    if (imageList.isEmpty) {
      return const Center(child: Text("No items to display."));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageList[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, size: 50),
            ),
          );
        },
      ),
    );
  }
}
