import 'package:flutter/material.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/model/live_follower_model.dart';
import 'package:zatch_app/model/product_model.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';
import 'package:zatch_app/view/zatching_details_screen.dart';

class LiveStreamScreen extends StatefulWidget {
  final LiveFollowerModel user;
  final UserProfileResponse? userProfile;

  const LiveStreamScreen( {super.key, required this.user, this.userProfile});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late LiveStreamController controller;

  @override
  void initState() {
    super.initState();
    controller = LiveStreamController(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.network(widget.user.image, fit: BoxFit.cover),
            ),

            // Top Profile Bar
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.openProfile(context),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.image),
                          radius: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.user.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const Text("5.0 ⭐ · 32K",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.remove_red_eye, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text("4.2k",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("Live",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Actions
            Positioned(
              right: 12,
              top: 300,
              child: Column(
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.share, color: Colors.white, size: 28),
                    onPressed: () => controller.share(context),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      controller.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                      controller.isLiked ? Colors.redAccent : Colors.white,
                      size: 30,
                    ),
                    onPressed: () => setState(() {
                      controller.toggleLike(context);
                    }),
                  ),
                  const Text("4.2k", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      controller.isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => setState(() {
                      controller.toggleSave(context);
                    }),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart,
                        color: Colors.white, size: 28),
                    onPressed: () => controller.addToCart(context),
                  ),
                ],
              ),
            ),

            // Bottom Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live Chat
                    SizedBox(
                      height: 100,
                      child: ListView(
                        children: const [
                          ChatBubble(user: "John", message: "Haha looks fun 😂"),
                          ChatBubble(user: "Alice", message: "I love this! ❤️"),
                          ChatBubble(user: "Sam", message: "🔥🔥🔥"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Product Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Products",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        GestureDetector(
                          onTap: () => _showCatalogueBottomSheet(context),
                          child: const Text("View All",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Product List (horizontal)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) {
                          final product = controller.products[index];
                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                              border:
                              Border.all(color: Colors.white24, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(product.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(product.category,
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text("${product.price} ₹",
                                          style: const TextStyle(
                                              color: Colors.greenAccent,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Buy / Zatch buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFCCF656)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => controller.buyNow(context),
                            child: const Text("Buy",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFCCF656)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => controller.zatchNow(context),
                            child: const Text("Zatch",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCatalogueBottomSheet(BuildContext context) {
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
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.black),
                      SizedBox(width: 8),
                      Text("Catalogue",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];

                        String? selectedSize; // no default
                        Color? selectedColor; // no default

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            product.imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(product.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                              Text("Dress modern",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        Text("${product.price} ₹",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Size options without tick
                                    Row(
                                      children: [
                                        const Text("Choose Size:",
                                            style: TextStyle(fontSize: 12)),
                                        const SizedBox(width: 8),
                                        ...["S", "M", "L", "XL"].map((s) =>
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 6),
                                              child: ChoiceChip(
                                                label: Text(s),
                                                selected: false, // always false
                                                onSelected: (_) =>
                                                    setState(() => selectedSize = s),
                                                selectedColor: Colors.transparent,
                                                backgroundColor: Colors.grey.shade200,
                                                labelStyle: const TextStyle(color: Colors.black),
                                              ),
                                            )),

                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Color options without tick
                                    Row(
                                      children: [
                                        const Text("Color:",
                                            style: TextStyle(fontSize: 12)),
                                        const SizedBox(width: 8),
                                        ...[
                                          Colors.green,
                                          Colors.black,
                                          Colors.grey
                                        ].map((c) => GestureDetector(
                                          onTap: () =>
                                              setState(() => selectedColor = c),
                                          child: Container(
                                            margin:
                                            const EdgeInsets.only(right: 8),
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: c,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.black26, // no selection tick
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Buy/Zatch Buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _showBuyOrZatchBottomSheet(
                                                  context, product, "buy");
                                            },
                                            child: const Text(
                                              "Buy",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              const Color(0xFFCCF656),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _showBuyOrZatchBottomSheet(
                                                  context, product, "zatch");
                                            },
                                            child: const Text(
                                              "Zatch",
                                              style: TextStyle(color: Colors.black),
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
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      side: const BorderSide(color: Colors.black),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
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
        double bargainPrice = 200;
        String selectedOption = defaultOption;

        return StatefulBuilder(builder: (context, setState) {
          double price = double.parse(product.price.replaceAll("₹", ""));
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

          return Padding(
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
                        child: Image.network(product.imageUrl,
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
                            child: Image.network(product.imageUrl,
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
                              max: 800,
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
          // Navigate to Checkout screen
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => CheckoutOrPaymentsScreen(isCheckout: true,),
          ),
          );
          } else {
          // Navigate to Bargain screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ZatchingDetailsScreen(
                  zatch: Zatch(
                    id: "temp1",
                    name: product.name,
                    description: product.category,
                    seller: "Seller Name", // optional
                    imageUrl: product.imageUrl,
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
          );
        });
      },
    );
  }

}

/// Chat Bubble
class ChatBubble extends StatelessWidget {
  final String user;
  final String message;

  const ChatBubble({super.key, required this.user, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(radius: 12, child: Text(user[0])),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("$user: $message",
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
