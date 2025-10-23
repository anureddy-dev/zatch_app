import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';
import 'package:zatch_app/view/profile/profile_screen.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';
import 'package:zatch_app/view/zatching_details_screen.dart';

class LiveStreamScreen extends StatefulWidget {
  final LiveStreamController controller;
  final String? username;

  const LiveStreamScreen({
    super.key,
    required this.controller,
    this.username,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  bool showComments = false;
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  int likeCount = 4200;
  int commentCount = 300;

  final List<Map<String, String>> demoMessages = [
    {"user": "SpeedySofa", "message": "First comment! Let's go! 🔥"},
    {"user": "EagleEye", "message": "What's the price on this one?"},
    {"user": "LunaLove", "message": "OMG I love this color! 😍"},
    {"user": "Gamer_God", "message": "OP gameplay as always!"},
    {"user": "RandomBot_77", "message": "Check out my profile for more! "},
    {"user": "Nikhil", "message": "Does it come in blue?"},
    {"user": "Anu", "message": "haha, this looks very funny 😄"},
    {"user": "QuietObserver", "message": "Just watching... looks cool."},
    {"user": "Priya_S", "message": "Can you show the back of the product please?"},
    {"user": "scOut Ka jabra fan", "message": "Shout out pls sir big fan 🙏"},
    {"user": "BargainHunter", "message": "Any discount available today?"},
    {"user": "Nikki", "message": "I love this ❤️"},
    {"user": "Yt gamer", "message": "This is op"},
  ];


  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    await widget.controller.fetchProducts();
    await _joinLiveSession();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _joinLiveSession() async {
    final username = widget.controller.session?.host?.username;

    if (username == null || username.isEmpty) return;

    try {
      final response = await ApiService().joinLiveSession(username);
      debugPrint("Joined Live Session: $response");
    } catch (e) {
      debugPrint("Failed to join live session: $e");
    }
  }
  void _toggleLike() {
    setState(() {
      if (widget.controller.isLiked) {
        likeCount--;
      } else {
        likeCount++;
      }
      widget.controller.toggleLike(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final session = controller.session;
    final product = controller.displayedProduct;
    final hostName = session?.host?.username ?? "Host";
    final rating = session?.host?.rating ?? "2";
    final hostProfilePic = session?.host?.profilePicUrl ?? "https://placehold.co/100x100?text=H";
    final productImage = product?.images.isNotEmpty == true
        ? product!.images.first.url
        : "https://placehold.co/100x100/222/FFF?text=Product";

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFCCF656)),
        ),
      );
    }

    return WillPopScope(
      onWillPop: ()async{
        if (showComments) {
          setState(() {
            showComments = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.network(
                session?.host?.profilePicUrl ??
                    "https://placehold.co/428x926/333/FFF?text=Live+Stream",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Host info
            Positioned(
              top: 45,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(userId: session?.host?.id ?? ""),
                      ),
                    );
                  },
                    child: Row(
                      children: [
                        CircleAvatar(radius: 24, backgroundImage: NetworkImage(hostProfilePic)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                             Text(
                             "⭐ $rating  ⭐ ${session?.viewersCount} " ?? "⭐ 5.0  •  32k",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          "${session?.viewersCount} Live" ?? "4.2k  Live",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right-side icons
            Positioned(
              right: 15,
              bottom: 250,
              child: Column(
                children: [
                  _SidebarItem(icon: Icons.share_outlined, onTap: () {
                    controller.share(context);
                  }),
                  const SizedBox(height: 20),
                  _SidebarItem(
                    icon: controller.isLiked ? Icons.favorite : Icons.favorite_border,
                    label: likeCount.toString(),
                    onTap: _toggleLike,
                  ),
                  const SizedBox(height: 20),
                  _SidebarItem(
                    icon: Icons.chat_bubble_outline,
                    label: commentCount.toString(),
                    onTap: () => setState(() => showComments = !showComments),
                  ),
                  const SizedBox(height: 20),
                  _SidebarItem(
                    icon: controller.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    onTap: () {
                      controller.toggleSave(context);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  _SidebarItem(
                    icon: Icons.shopping_cart_outlined,
                    onTap: () => controller.addToCart(context),
                  ),
                ],
              ),
            ),

            // Product & Comments
            if (!showComments) ...[
              Positioned(
                left: 20,
                right: 80,
                bottom: 250,
                height: 120,
                child: GestureDetector(
                  onTap: () => setState(() => showComments = true),
                  child: AbsorbPointer(
                    absorbing: false,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: demoMessages.length,
                      itemBuilder: (context, index) {
                        final message = demoMessages.reversed.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),

                          child: _ChatBubble(
                            user: message["user"] ?? "User",
                            message: message["message"] ?? "",
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 20,
                right: 20,
                bottom: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    GestureDetector(
                      onTap: () => _showCatalogueBottomSheet(context),
                      child: const Text(
                        "View all",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 110,
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.products.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    final productImage = product.images.isNotEmpty
                        ? product.images.first.url
                        : "https://placehold.co/100x100/222/FFF?text=P";
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Container(
                          width: 350,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(productImage,
                                    width: 54, height: 54, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      product.category?.name ?? "Category",
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Text("${product.price} ₹",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 25,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCatalogueBottomSheet(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCCF656)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Zatch",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showCatalogueBottomSheet(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCCF656),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Buy",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ]
            else ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 35,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height * 0.45, // Half screen height
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // 🔹 Chat Messages
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: ListView.builder(
                            itemCount: demoMessages.length,
                            reverse: false,
                            itemBuilder: (context, index) {
                              final msg = demoMessages[index];
                              final isSuperchat = msg["type"] == "superchat";

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Avatar Circle
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white24,
                                      backgroundImage: msg["avatar"] != null
                                          ? AssetImage(msg["avatar"]!)
                                          : null,
                                      child: msg["avatar"] == null
                                          ? Text(
                                        (msg["user"] ?? "?")[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 10),

                                    // Name + Message
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg["user"] ?? "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            msg["message"] ?? "",
                                            style: TextStyle(
                                              color: isSuperchat
                                                  ? const Color(0xFFFFD700)
                                                  : Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 🔹 Comment Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                        child: Row(
                          children: [
                            // 🔹 Back Button (white rounded)
                            Container(
                              width: 50,
                              height: 50,

                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () => setState(() => showComments = false),
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // 🔹 Comment Bar
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    // Comment Input
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: "Comment",
                                          hintStyle: TextStyle(color: Colors.white54),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),

                                    // Send Button (Neon Green)
                                    GestureDetector(
                                      onTap: () {
                                        if (_commentController.text.trim().isEmpty) return;
                                        setState(() {
                                          demoMessages.add({
                                            "user": widget.username ?? "You",
                                            "message": _commentController.text.trim(),
                                          });
                                          _commentController.clear();
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFCCFF55), // Neon green
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.send,
                                          color: Colors.black,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ]

          ],
        ),
      ),
    );
  }

  /// ✅ Bottom Sheet (View All Products)

  Color _getColorFromString(String colorString) {
    switch (colorString.toUpperCase()) {
      case 'BLUE':
        return Colors.blue;
      case 'BLACK':
        return Colors.black;
      case 'BEIGE':
        return const Color(0xFFF5F5DC);
      case 'RED':
        return Colors.red;
      case 'WHITE':
        return Colors.white;
      case 'DUSKY PURPLE':
        return const Color(0xFF895B8A);
      case 'GREEN':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showCatalogueBottomSheet(BuildContext context) {
    final products = widget.controller.products;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (context, scrollController) {
            // FIX 2: Removed horizontal padding from the root Padding widget.
            // This allows the ListView to be full-width, and we can control
            // the padding of each card individually.
            return Column(
              children: [
                const SizedBox(height: 16),
                // Top bar
                Padding(
                  // Add padding here to align the top bar content.
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                      ),
                       const Expanded(
                        child: Center(
                          child: Text(
                            "Catalogue",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24), // Balances the space of the back arrow Icon.
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade300, height: 1),
                const SizedBox(height: 16),
                // Product list
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      String? selectedSize = product.size;
                      Color? selectedColor = _getColorFromString(product.color.toString());
                      final availableSizes = ["S", "M", "L", "XL"];
                      final availableColors = [
                        _getColorFromString("BLUE"),
                        _getColorFromString("BLACK"),
                        _getColorFromString("BEIGE"),
                        _getColorFromString("RED"),
                        _getColorFromString("WHITE"),
                        _getColorFromString("DUSKY PURPLE"),
                        _getColorFromString("GREEN"),
                      ];

                      return StatefulBuilder(
                        builder: (context, setState) {
                          final bool areOptionsSelected = selectedSize != null && selectedColor != null;
                          return GestureDetector(onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen( productId: product.id),
                              ),
                            );
                          },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product info row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          product.images.isNotEmpty
                                              ? product.images.first.url
                                              : "https://placehold.co/95x118",
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4.5),
                                            Text(
                                              product.name,
                                              style: const TextStyle(
                                                color: Color(0xFF121111),
                                                fontSize: 14,
                                                fontFamily: 'Encode Sans',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  product.category?.name  ??'Dress modern',
                                                  style: const TextStyle(
                                                    color: Color(0xFF787676),
                                                    fontSize: 10,
                                                    fontFamily: 'Encode Sans',
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  product.likeCount != null
                                                      ? "${product.likeCount} ⭐"
                                                      : "⭐ 5.0",
                                                  style: const TextStyle(
                                                    color: Color(0xFF121111),
                                                    fontSize: 10,
                                                    fontFamily: 'Encode Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 14.0),
                                        child: Text(
                                          "${product.price.toStringAsFixed(2)} ₹",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Encode Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Size and Color options
                                  Row(
                                    children: [
                                      // Size options
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text( 'Choose Size', style: TextStyle( color: Color(0xFF121111), fontSize: 12, fontFamily: 'Encode Sans', fontWeight: FontWeight.w700, ), ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: availableSizes.map((s) {
                                                final isSelected = selectedSize?.toLowerCase() == s.toLowerCase();
                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: GestureDetector(
                                                    onTap: () => setState(() => selectedSize = s),
                                                    child: Container(
                                                      width: 26, height: 26, alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: isSelected ? const Color(0xFF292526) : Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all( color: const Color(0xFFDFDEDE), width: 1, ),
                                                      ),
                                                      child: Text( s, style: TextStyle( color: isSelected ? const Color(0xFFFDFDFD) : const Color(0xFF292526), fontSize: 12, fontFamily: 'Encode Sans', fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, ),),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Color options
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text( 'Color', style: TextStyle( color: Color(0xFF121111), fontSize: 12, fontFamily: 'Encode Sans', fontWeight: FontWeight.w700, ), ),
                                            const SizedBox(height: 8),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: availableColors.map((c) {
                                                  final isSelected = selectedColor == c;
                                                  // FIX 1: Wrap the color circle in a padded container.
                                                  // This gives the border space to draw without being clipped.
                                                  return GestureDetector(
                                                    onTap: () => setState(() => selectedColor = c),
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 8),
                                                      // This container draws the border and has padding.
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: isSelected ? Border.all( color: const Color(0xFFAFE80C), width: 2, ) : null,
                                                      ),
                                                      // This inner container is the colored circle.
                                                      child: Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration: BoxDecoration(
                                                          color: c,
                                                          shape: BoxShape.circle,
                                                          // Add a thin border for white color to be visible on white background
                                                          border: c == Colors.white ? Border.all(color: Colors.grey.shade300) : null,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Buy + Zatch buttons
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const ShapeDecoration(
                                            shape: OvalBorder( side: BorderSide( width: 2, color: Color(0xFFCCF656), ), ),
                                          ),
                                          child: const Center( child: Icon( Icons.shopping_cart_outlined, color: Colors.black, size: 24, ), ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Opacity(
                                          opacity: areOptionsSelected ? 1.0 : 0.5,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom( side: const BorderSide( width: 2, color: Color(0xFFCCF656), ), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16), ), minimumSize: const Size.fromHeight(50), ),
                                            onPressed:areOptionsSelected ? () {
                                              Navigator.pop(context);
                                               _showBuyOrZatchBottomSheet(context, product, "buy");
                                            }: null,
                                            child: const Text( 'Buy', style: TextStyle( color: Colors.black, fontSize: 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, ), ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Opacity(
                                          opacity: areOptionsSelected ? 1.0 : 0.5,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom( backgroundColor: const Color(0xFFCCF656), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16), ), minimumSize: const Size.fromHeight(50), ),
                                            // Disable button if options are not selected
                                            onPressed: areOptionsSelected ? () {
                                              Navigator.pop(context);
                                               _showBuyOrZatchBottomSheet(context, product, "zatch");
                                            } : null,
                                            child: const Text( 'Zatch', style: TextStyle( color: Colors.black, fontSize: 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, ), ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Cancel button
                Padding(
                  // Add horizontal padding here to match the cards.
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showBuyOrZatchBottomSheet(
      BuildContext context, Product product, String defaultOption) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int quantity = 1;
        double bargainPrice = product.price;
        String selectedOption = defaultOption;

        return StatefulBuilder(builder: (context, setState) {
          double price = product.price;
          double subTotal = selectedOption == "buy"
              ? price * quantity
              : bargainPrice * quantity;

          Widget buildCard({
            required String value,
            required String title,
            required Widget child,
          }) {
            bool isSelected = selectedOption == value;
            return Column(
              children: [
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() => selectedOption = value),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: value,
                              groupValue: selectedOption,
                              onChanged: (val) =>
                                  setState(() => selectedOption = val!),
                            ),
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        child,
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              _showCatalogueBottomSheet(context);
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // AppBar with back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context); // Close Buy/Zatch sheet
                          _showCatalogueBottomSheet(context); // Reopen catalogue
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Buy / Zatch",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  buildCard(
                    value: "buy",
                    title: "Buy Product",
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(product.images.first.url,
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              const Text("Dress modern",
                                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                              Text("${price.toStringAsFixed(2)} ₹",
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) setState(() => quantity--);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text("$quantity"),
                            IconButton(
                              onPressed: () => setState(() => quantity++),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  buildCard(
                    value: "zatch",
                    title: "Zatch",
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(product.images.first.url,
                                  width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14)),
                                  const Text("Dress modern",
                                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Text("${price.toStringAsFixed(2)} ₹",
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) setState(() => quantity--);
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text("$quantity"),
                                IconButton(
                                  onPressed: () => setState(() => quantity++),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text("Bargain Price"),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Slider(
                                value: bargainPrice,
                                min: 100,
                                max: price,
                                divisions: 14,
                                onChanged: (val) => setState(() => bargainPrice = val),
                              ),
                            ),
                            Text("${bargainPrice.toStringAsFixed(0)} ₹"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCCF656),
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (selectedOption == "buy") {
                        final itemToCheckout = CartItem(
                          name: product.name,
                          description: product.category?.name ?? "Live Stream Item", // Use category name or a default
                          price: product.price,
                          quantity: quantity, // The quantity selected in the bottom sheet
                          imageUrl: product.images.isNotEmpty
                              ? product.images.first.url
                              : "https://placehold.co/100x100?text=P",

                        );

                        // 2. Calculate the total prices.
                        double itemsTotal = itemToCheckout.price * itemToCheckout.quantity;
                        double shippingFee = 50.0; // Example shipping fee, or calculate as needed.
                        double subTotal = itemsTotal + shippingFee;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutOrPaymentsScreen(isCheckout: true,
                            selectedItems: [itemToCheckout],
                              itemsTotalPrice: itemsTotal,
                              shippingFee: shippingFee,
                              subTotalPrice: subTotal,),
                          ),
                        );
                      } else {
                        // Navigate to Bargain screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ZatchingDetailsScreen(
                              zatch: Zatch(
                                id: "temp1",
                                name: product.name,
                                description: product.category?.description ?? "",
                                seller: "Seller Name", // optional
                                imageUrl: product.images.first.url,
                                active: true,
                                status: "My Offer",
                                quotePrice: "${bargainPrice.toStringAsFixed(0)} ₹",
                                sellerPrice: "",
                                quantity: quantity,
                                subTotal: "${(bargainPrice * quantity).toStringAsFixed(0)} ₹",
                                date: DateTime.now().toString(),
                              ),
                            ),
                          ),
                        );

                      }
                    },
                    child: Text(selectedOption == "buy" ? "Buy" : "Bargain"),
                  )

                ],
              ),
            ),
          );
        });
      },
    );
  }

}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _SidebarItem({required this.icon, this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(label!,
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
class _ChatBubble extends StatelessWidget {
  final String user;
  final String message;

  const _ChatBubble({
    required this.user,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage("https://placehold.co/40x40"), // demo
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

