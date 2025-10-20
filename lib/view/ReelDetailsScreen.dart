import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/bit_details.dart'; // Import the model
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';
import 'package:zatch_app/view/zatching_details_screen.dart'; // Import the service

class ReelDetailsScreen extends StatefulWidget {
  final String bitId;
  final String productImage = "https://picsum.photos/id/102/200/200";
  final LiveStreamController? controller;

  const ReelDetailsScreen({
    super.key,
    required this.bitId,
    this.controller,
  });

  @override
  State<ReelDetailsScreen> createState() => _ReelDetailsScreenState();
}

// Add WidgetsBindingObserver to listen to app lifecycle events
class _ReelDetailsScreenState extends State<ReelDetailsScreen>
    with WidgetsBindingObserver {
  // API and Video State
  late VideoPlayerController _videoController;

  bool _isLoading = true;
  bool _isVideoInitialized = false;
  BitDetails? _bitDetails;

  // UI State
  bool isLiked = false;
  bool isSaved = false;
  bool showComments = false;
  int likeCount = 4200;
  int commentCount = 300;
  final TextEditingController _commentController = TextEditingController();

  List<Map<String, dynamic>> demoMessages = [
    {"user": "Riya", "message": "This is awesome! 🔥"},
    {"user": "Karan", "message": "Love this product 😍"},
  ];

  @override
  void initState() {
    super.initState();
    // Register the observer
    WidgetsBinding.instance.addObserver(this);
    _initializeReel();
  }

  /// Pause video before navigating and resume when returning.
  Future<void> _pushAndPause(Widget page) async {
    if (_isVideoInitialized) _videoController.pause();
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted && _isVideoInitialized) {
      _videoController.play();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Handles app being minimized or switched.
    if (!_isVideoInitialized) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _videoController.pause();
    } else if (state == AppLifecycleState.resumed) {
      _videoController.play();
    }
  }

// In _ReelDetailsScreenState

  Future<void> _initializeReel() async {
    try {
      await widget.controller?.fetchProducts();
      final bitDetails = await ApiService().fetchBitDetails(widget.bitId);
      _bitDetails = bitDetails;
      if (bitDetails.video.url.isNotEmpty) {
        final videoUrl = bitDetails.video.url.replaceFirst(
          '/upload/',
          '/upload/q_auto:good/',
        );

        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await _videoController.initialize();
        _videoController.play();
        _videoController.setLooping(true);
        _isVideoInitialized = true;
      } else {
        debugPrint("Video URL is empty.");
      }
    } catch (e) {
      debugPrint("Failed to initialize reel: $e");
    } finally {
      // 4. Update the UI
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isVideoInitialized) {
      _videoController.dispose();
    }
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final product = controller?.displayedProduct;
    final productImage = product?.images.isNotEmpty == true
        ? product!.images.first.url
        : "https://placehold.co/100x100/222/FFF?text=Product";

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (_bitDetails == null || !_isVideoInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            leading: const BackButton(color: Colors.white)),
        body: const Center(
          child: Text("Failed to load reel.",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // Once loaded, build the main UI
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🎥 Background Video Player
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() { // Wrap in setState to rebuild the UI if you have a play/pause icon
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                });
              },
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          ),

          // 🔹 Top Host Info Bar (using placeholder data for now)
          Positioned(
            top: 45,
            left: 20,
            right: 20,
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 24,
                    backgroundImage:
                    NetworkImage("https://picsum.photos/id/237/200/200")),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _bitDetails!.title, // Using title from API
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _bitDetails!.description, // Using description from API
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 Right-side action icons (using data from API)
          Positioned(
            right: 15,
            bottom: 250,
            child: Column(
              children: [
                _SidebarItem(
                    icon: Icons.share_outlined,
                    label: _bitDetails!.shareCount.toString(),
                    onTap: () { controller?.share(context);}),
                const SizedBox(height: 20),
                _SidebarItem(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: likeCount.toString(),
                  onTap: _toggleLike,
                ),
                const SizedBox(height: 20),
                _SidebarItem(
                  icon: Icons.chat_bubble_outline,
                  label: "300", // Comment count not in API, using static
                  onTap: () => setState(() => showComments = !showComments),
                ),
                const SizedBox(height: 20),
                _SidebarItem(
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  onTap: () => setState(() => isSaved = !isSaved),
                ),
                const SizedBox(height: 20),
                _SidebarItem(
                  icon: Icons.shopping_cart_outlined,
                  onTap: () => _pushAndPause(CartScreen()),
                ),
              ],
            ),
          ),
          // 🔹 Product & Comments (toggle sections)
          if (!showComments) ...[
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
                    onTap: () {
                      _videoController.pause();
                      _showCatalogueBottomSheet(context).then((_) {
                        if (mounted) {
                          _videoController.play();
                        }
                      });
                    },
                    child: const Text(
                      "View all",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            // Product Card
            Positioned(
              left: 0,
              right: 0,
              bottom: 110,
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller?.products.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final product = widget.controller?.products[index];
                  final productImage = product?.images != null
                      ? product?.images.first.url
                      : "https://placehold.co/100x100/222/FFF?text=P";
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(
                                    productId: product?.id ?? ""),
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
                              child: Image.network(productImage ?? "",
                                  width: 54, height: 54, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product?.name ?? "Product Name",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product?.category?.name ?? "Category",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Text("${product?.price} ₹",
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

            // Action Buttons
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
                        RoundedRectangleBorder(borderRadius: BorderRadius
                            .circular(12)),
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
          ] else
            ...[
              // Comments Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 35,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      // Comments List
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: ListView.builder(
                            itemCount: demoMessages.length,
                            itemBuilder: (context, index) {
                              final msg = demoMessages[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white24,
                                      child: Text(
                                        (msg["user"] ?? "?")[0].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(msg["user"] ?? "",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                          const SizedBox(height: 2),
                                          Text(msg["message"] ?? "",
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13)),
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
                      // Comment Input Bar
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            12,
                            4,
                            12,
                            MediaQuery
                                .of(context)
                                .padding
                                .bottom +
                                10),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    setState(() => showComments = false),
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.2)),
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        style:
                                        const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: "Comment...",
                                          hintStyle:
                                          TextStyle(color: Colors.white54),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (_commentController.text
                                            .trim()
                                            .isEmpty) return;
                                        setState(() {
                                          demoMessages.add({
                                            "user":
                                            "You",
                                            // Or fetch current user's name
                                            "message":
                                            _commentController.text.trim(),
                                          });
                                          _commentController.clear();
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFCCFF55),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.send,
                                            color: Colors.black, size: 22),
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
            ],
        ],
      ),
    );
  }

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

 Future<void> _showCatalogueBottomSheet(BuildContext context) async {
    final products = widget.controller?.products;

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
                        child: const Icon(
                            Icons.arrow_back_ios, color: Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Catalogue",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Balances the space of the back arrow Icon.
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
                    itemCount: products?.length,
                    itemBuilder: (context, index) {
                      final product = products?[index];
                      String? selectedSize = product?.size;
                      Color? selectedColor = _getColorFromString(product?.color
                          ?? "");
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
                          final bool areOptionsSelected = selectedSize !=
                              null && selectedColor != null;
                          return GestureDetector(onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(productId: product?.id ??""),
                              ),
                            );
                          },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 16, left: 16, right: 16),
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          product?.images != null
                                              ? "${product?.images.first.url}"
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
                                              product?.name ?? 'Product Name',
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
                                                  product?.category?.name ??
                                                      'Dress modern',
                                                  style: const TextStyle(
                                                    color: Color(0xFF787676),
                                                    fontSize: 10,
                                                    fontFamily: 'Encode Sans',
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  product?.likeCount != null
                                                      ? "${product?.likeCount} ⭐"
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
                                        padding: const EdgeInsets.only(
                                            top: 14.0),
                                        child: Text(
                                          "${product?.price.toStringAsFixed(
                                              2)} ₹",
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            const Text('Choose Size',
                                              style: TextStyle(
                                                color: Color(0xFF121111),
                                                fontSize: 12,
                                                fontFamily: 'Encode Sans',
                                                fontWeight: FontWeight.w700,),),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: availableSizes.map((s) {
                                                final isSelected = selectedSize
                                                    ?.toLowerCase() ==
                                                    s.toLowerCase();
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .only(right: 8),
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        setState(() =>
                                                        selectedSize = s),
                                                    child: Container(
                                                      width: 26,
                                                      height: 26,
                                                      alignment: Alignment
                                                          .center,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? const Color(
                                                            0xFF292526)
                                                            : Colors
                                                            .transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xFFDFDEDE),
                                                          width: 1,),
                                                      ),
                                                      child: Text(s,
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? const Color(
                                                              0xFFFDFDFD)
                                                              : const Color(
                                                              0xFF292526),
                                                          fontSize: 12,
                                                          fontFamily: 'Encode Sans',
                                                          fontWeight: isSelected
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                              .w400,),),
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            const Text('Color',
                                              style: TextStyle(
                                                color: Color(0xFF121111),
                                                fontSize: 12,
                                                fontFamily: 'Encode Sans',
                                                fontWeight: FontWeight.w700,),),
                                            const SizedBox(height: 8),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: availableColors.map((
                                                    c) {
                                                  final isSelected = selectedColor ==
                                                      c;
                                                  // FIX 1: Wrap the color circle in a padded container.
                                                  // This gives the border space to draw without being clipped.
                                                  return GestureDetector(
                                                    onTap: () =>
                                                        setState(() =>
                                                        selectedColor = c),
                                                    child: Container(
                                                      margin: const EdgeInsets
                                                          .only(right: 8),
                                                      // This container draws the border and has padding.
                                                      padding: const EdgeInsets
                                                          .all(2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: isSelected
                                                            ? Border.all(
                                                          color: const Color(
                                                              0xFFAFE80C),
                                                          width: 2,)
                                                            : null,
                                                      ),
                                                      // This inner container is the colored circle.
                                                      child: Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration: BoxDecoration(
                                                          color: c,
                                                          shape: BoxShape
                                                              .circle,
                                                          // Add a thin border for white color to be visible on white background
                                                          border: c ==
                                                              Colors.white
                                                              ? Border.all(
                                                              color: Colors.grey
                                                                  .shade300)
                                                              : null,
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
                                            shape: OvalBorder(side: BorderSide(
                                              width: 2,
                                              color: Color(0xFFCCF656),),),
                                          ),
                                          child: const Center(child: Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.black, size: 24,),),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Opacity(
                                          opacity: areOptionsSelected
                                              ? 1.0
                                              : 0.5,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(width: 2,
                                                color: Color(0xFFCCF656),),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(16),),
                                              minimumSize: const Size
                                                  .fromHeight(50),),
                                            onPressed: areOptionsSelected ? () {
                                              Navigator.pop(context);
                                              _showBuyOrZatchBottomSheet(
                                                  context, product, "buy");
                                            } : null,
                                            child: const Text('Buy',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w400,),),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Opacity(
                                          opacity: areOptionsSelected
                                              ? 1.0
                                              : 0.5,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                  0xFFCCF656),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(16),),
                                              minimumSize: const Size
                                                  .fromHeight(50),),
                                            // Disable button if options are not selected
                                            onPressed: areOptionsSelected ? () {
                                              Navigator.pop(context);
                                              _showBuyOrZatchBottomSheet(
                                                  context, product, "zatch");
                                            } : null,
                                            child: const Text('Zatch',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w400,),),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
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

  void _showBuyOrZatchBottomSheet(BuildContext context, Product? product,
      String defaultOption) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int quantity = 1;
        double bargainPrice = product?.price ?? 0;
        String selectedOption = defaultOption;

        return StatefulBuilder(builder: (context, setState) {
          double price = product?.price ?? 0;
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
                          color: isSelected ? Colors.black : Colors.grey
                              .shade300,
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
                          _showCatalogueBottomSheet(
                              context); // Reopen catalogue
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
                          child: Image.network(product?.images.first.url ?? "",
                              width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product?.name ??"",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const Text("Dress modern",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              Text("${price.toStringAsFixed(2)} ₹",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
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
                              child: Image.network(product?.images.first.url ?? "",
                                  width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product?.name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const Text("Dress modern",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                  Text("${price.toStringAsFixed(2)} ₹",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity >
                                        1) setState(() => quantity--);
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
                                onChanged: (val) =>
                                    setState(() => bargainPrice = val),
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
                        // Navigate to Checkout screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CheckoutOrPaymentsScreen(isCheckout: true,),
                          ),
                        );
                      } else {
                        // Navigate to Bargain screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ZatchingDetailsScreen(
                                  zatch: Zatch(
                                    id: "temp1",
                                    name: product?.name ?? '',
                                    description: product?.category ?.description ?? "",
                                    seller: "Seller Name",
                                    // optional
                                    imageUrl: product?.images.first.url ?? '',
                                    active: true,
                                    status: "My Offer",
                                    quotePrice: "${bargainPrice.toStringAsFixed(
                                        0)} ₹",
                                    sellerPrice: "",
                                    quantity: quantity,
                                    subTotal: "${(bargainPrice * quantity)
                                        .toStringAsFixed(0)} ₹",
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

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }
    });
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
