import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zatch_app/model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final TabController _tabController;
  int _selectedSizeIndex = 1;
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  final List<String> productImages = [
    'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=500&q=80',
    'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=500&q=80',
    'https://images.unsplash.com/photo-1588117260148-b4782679c674?w=500&q=80',
  ];

  final List<Product> similarProducts = [
    Product(name: "Men's Harrington Jacket", category: 'Jackets', price: '\$148.00', imageUrl: 'https://images.unsplash.com/photo-1591047139829-d916b67ea74f?w=500&q=80', discount: '50%', soldCount: 1200),
    Product(name: "Hype Cotton terry Slides", category: 'Footwear', price: '\$148.00', imageUrl: 'https://images.unsplash.com/photo-1603487742131-412903b6e82b?w=500&q=80', discount: '50%', soldCount: 1200),
    Product(name: "Men's Harrington Jacket", category: 'Jackets', price: '\$148.00', imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500&q=80', discount: '50%', soldCount: 1200),
  ];

  final List<Review> reviews = [
    Review(userName: 'Veronika', userAvatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg', rating: 5, comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod...'),
    Review(userName: 'Esther', userAvatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg', rating: 4, comment: 'I love this so much! Stay long.'),
    Review(userName: 'Eren Yeager', userAvatarUrl: 'https://randomuser.me/api/portraits/men/33.jpg', rating: 5, comment: 'This is very refreshing 😄'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
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
                  _buildSizeSelector(),
                  const SizedBox(height: 24),
                  _buildColorSelector(),
                  const SizedBox(height: 24),
                  _buildInfoTabs(),
                  const SizedBox(height: 24),
                  _buildProductSection("Similar Products", similarProducts),
                  const SizedBox(height: 24),
                  _buildPolicySection(),
                  const SizedBox(height: 24),
                  _buildProductSection("Products from This Seller", similarProducts.reversed.toList()),
                  const SizedBox(height: 24),
                  _buildProductSection("Bargain Picks For You", similarProducts),
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

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
      actions: const [
        Icon(Icons.share_outlined, color: Colors.black),
        SizedBox(width: 16),
        Icon(Icons.favorite_border, color: Colors.black),
        SizedBox(width: 16),
        Icon(Icons.shopping_bag_outlined, color: Colors.black),
        SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  productImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: productImages.length,
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
      children: const [
        Text(
          'Light Dress Bless',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '20.99 \$',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      'Its simple and elegant shape makes it perfect for those of you who like feminine and minimalist styles.',
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
    );
  }

  Widget _buildSizeSelector() {
    final List<String> sizes = ['S', 'M', 'L', 'XL'];
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

  Widget _buildColorSelector() {
    final List<Color> colors = [Colors.black, Colors.grey.shade400, Colors.blue.shade900];
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
            Tab(text: 'Community(15)'),
            Tab(text: 'Reviews'),
          ],
        ),
        SizedBox(
          // Using a fixed height for simplicity, can be made dynamic
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBasicInfoTab(),
              _buildCommunityTab(),
              _buildReviewsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Info", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products."),
            SizedBox(height: 16),
            Text("Measurements", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("To keep your jackets and coats clean, you only need to freshen them up and go over them with a cloth or a clothes brush. If you need to dry clean a garment, look for a dry cleaner that uses technology that is respectful of the environment."),

          ],
        )
    );
  }

  Widget _buildCommunityTab() {
    return const Center(child: Text("Community Info Goes Here"));
  }

  Widget _buildReviewsTab() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(review.userAvatarUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (starIndex) => Icon(
                        starIndex < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      )),
                    ),
                    const SizedBox(height: 8),
                    Text(review.comment, style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.discount,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('${product.soldCount} sold this week', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(product.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPolicySection() {
    return Column(
      children: const [
        ExpansionTile(
          title: Text("Free Flat Rate Shipping"),
          trailing: Icon(Icons.keyboard_arrow_down),
          children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about free flat rate shipping."))],
        ),
        ExpansionTile(
          title: Text("COD Policy"),
          trailing: Icon(Icons.keyboard_arrow_down),
          children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about our Cash On Delivery policy."))],
        ),
        ExpansionTile(
          title: Text("Return Policy"),
          trailing: Icon(Icons.keyboard_arrow_down),
          children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about our return policy."))],
        ),
      ],
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
}