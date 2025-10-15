/*
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  Product? product;
  List<Product> topPicks = [];
  bool loading = true;
  bool topPicksLoading = true;

  final PageController _pageController = PageController();
  late TabController _tabController;
  int _selectedSizeIndex = 0;
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchProductDetails();
    _fetchTopPicks();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final fetchedProduct = await _apiService.getProductById(widget.productId);
      if (mounted) {
        setState(() {
          product = fetchedProduct;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load product: $e")),
        );
      }
    }
  }

  Future<void> _fetchTopPicks() async {
    try {
      final fetchedTopPicks = await _apiService.getTopPicks();
      if (mounted) {
        setState(() {
          topPicks = fetchedTopPicks;
          topPicksLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => topPicksLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final images = product!.images.isNotEmpty
        ? product!.images.map((e) => e.url).toList()
        : ['https://via.placeholder.com/150'];
    final sizes = product!.size != null ? [product!.size!] : ['S', 'M', 'L', 'XL'];
    final colors = product!.color != null ? [Colors.blue] : [Colors.black, Colors.grey, Colors.blue];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(images),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildTitleAndPrice(),
                  const SizedBox(height: 8),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildSizeSelector(sizes),
                  const SizedBox(height: 24),
                  _buildColorSelector(colors),
                  const SizedBox(height: 24),
                  _buildInfoTabs(),
                  const SizedBox(height: 24),
                  if (!topPicksLoading)
                    _buildProductSection("Top Picks", topPicks),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildSliverAppBar(List<String> images) {
    return SliverAppBar(
      expandedHeight: 400.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () => _likeProduct(),
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product!.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${product!.price} ₹',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      product!.description ?? '',
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
    );
  }

  Widget _buildSizeSelector(List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(sizes.length, (index) {
            final isSelected = _selectedSizeIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedSizeIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    sizes[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildColorSelector(List<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(colors.length, (index) {
            final isSelected = _selectedColorIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedColorIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blueAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: colors[index],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Basic Info'),
            Tab(text: 'Community'),
            Tab(text: 'Reviews'),
          ],
        ),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBasicInfoTab(),
              const Center(child: Text("Community Info Goes Here")),
              const Center(child: Text("Reviews will be displayed here")),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(product!.info1 ?? ''),
    );
  }

  Widget _buildProductSection(String title, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text('View all', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductCard(products[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    final imageUrl = product.images.isNotEmpty ? product.images.first.url : 'https://via.placeholder.com/150';
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id)),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl, height: 150, width: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('${product.likeCount} likes', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text('${product.price} ₹', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.blueAccent),
              ),
              child: const Text('Zatch', style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text('Buy'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _likeProduct() async {
    if (product == null) return;
    try {
      final updatedCount = await _apiService.likeProduct(product!.id);
      setState(() => product?.likeCount = updatedCount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to like product: $e")),
      );
    }
  }
}
*/
