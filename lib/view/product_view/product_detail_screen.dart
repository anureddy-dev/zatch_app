import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productId; // pass product id

  const ProductDetailScreen({super.key,  this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _pageController = PageController();
  String _selectedSize = 'L';
  int _selectedColorIndex = 0;
  int _selectedTabIndex = 0;

  Product? product; // fetched product
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    try {
      final products = await ApiService().getProducts(); // fetch all
      final found = products.firstWhere((p) => p.id == widget.productId);
      setState(() {
        product = found;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching product: $e");
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9C94E8),
      body: Stack(
        children: [
          _buildImageCarousel(),
          _buildHeaderIcons(),
          _buildPageIndicator(),
          _buildContentSheet(),
        ],
      ),
    );
  }

  // --- IMAGE CAROUSEL ---
  Widget _buildImageCarousel() {
    return Positioned.fill(
      child: PageView.builder(
        controller: _pageController,
        itemCount: product!.images.isEmpty ? 1 : product!.images.length,
        itemBuilder: (_, index) {
          final imgUrl = product!.images.isNotEmpty
              ? product!.images[index].url
              : "https://via.placeholder.com/400";
          return Image.network(imgUrl, fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _buildHeaderIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleIcon(Icons.arrow_back, onTap: () => Navigator.pop(context)),
          Row(
            children: [
              _buildCircleIcon(Icons.bookmark_border),
              const SizedBox(width: 12),
              _buildCircleIcon(Icons.shopping_cart_outlined, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.60,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: _pageController,
          count: product!.images.isEmpty ? 1 : product!.images.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.white,
            dotColor: Colors.white54,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndPrice(),
              const SizedBox(height: 8),
              _buildRating(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildSizeSelector(),
              const SizedBox(height: 24),
              _buildColorSelector(),
              const SizedBox(height: 24),
              _buildInfoTabs(),
              const SizedBox(height: 16),
              _buildTabContent(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton("Zatch", onPressed: () {
                    debugPrint("Zatch clicked");
                  }),
                  const SizedBox(width: 10),
                  _buildButton("Buy", onPressed: () {
                    debugPrint("Buy clicked");
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- DYNAMIC CONTENT ---
  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(product!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text("${product!.price} ₹", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(product!.description, style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.4));
  }

  // --- Keep your existing size/color/tab logic ---
  Widget _buildSizeSelector() { /* ...same as yours... */ return Container(); }
  Widget _buildColorSelector() { /* ...same as yours... */ return Container(); }
  Widget _buildInfoTabs() { /* ...same as yours... */ return Container(); }
  Widget _buildTabContent() { /* ...same as yours... */ return Container(); }

  Widget _buildRating() {
    return Row(
      children: const [
        Icon(Icons.star, color: Colors.amber, size: 20),
        SizedBox(width: 4),
        Text('5.0', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        Text('(7,932 reviews)', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildCircleIcon(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
    );
  }

  Widget _buildButton(String label, {VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFDAFF00),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: Text(label),
      ),
    );
  }
}
