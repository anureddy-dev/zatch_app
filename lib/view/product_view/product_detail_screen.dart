import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zatch_app/Widget/bargain_picks_widget.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';

class Review {
  final String userName;
  final String userAvatarUrl;
  final int rating;
  final String comment;

  Review({
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
  });
}
class Comment {
  final String userName;
  final String userAvatar;
  final String text;
  final String timeAgo;
  final int likes;

  Comment({
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timeAgo,
    required this.likes,
  });
}

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final TabController _tabController;
  int _selectedSizeIndex = 2;
  int _selectedColorIndex = 1;
  final ApiService _apiService = ApiService();

  bool loading = true;
  String? errorMessage;
  late Product product;
  List<Product> similarProducts = [];
  bool _showAllInfo = false;
  bool _showAllCommunity = false;
  bool _showAllReviews = false;

  final List<Review> reviews = [
    Review(
        userName: 'Veronika',
        userAvatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        rating: 5,
        comment: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...'),
    Review(
        userName: 'Esther',
        userAvatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
        rating: 4,
        comment: 'I love this so much! Stay long.'),
    Review(
        userName: 'Eren Yeager',
        userAvatarUrl: 'https://randomuser.me/api/portraits/men/33.jpg',
        rating: 5,
        comment: 'This is very refreshing 😄'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProductDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });
    try {
      final fetchedProduct = await _apiService.getProductById(widget.productId);
      final fetchedSimilarProducts = await _apiService.getTopPicks();

      if (mounted) {
        setState(() {
          product = fetchedProduct;
          similarProducts = fetchedSimilarProducts;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Failed to load product: $e";
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildTitlePriceAndRating(),
                  const SizedBox(height: 16),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildSizeSelector(),
                  const SizedBox(height: 24),
                  _buildColorSelector(),
                  const SizedBox(height: 24),
                  _buildInfoTabs(),
                  const SizedBox(height: 24),
                  _buildProductSection("Similar Products", similarProducts),
                  const SizedBox(height: 32),
                  _buildPolicySection(),
                  const SizedBox(height: 32),
                  _buildProductSection("Products from this Seller", similarProducts),
                  const SizedBox(height: 32),
                  const BargainPicksWidget(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildCircleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDFDEDE), width: 1),
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 450.0,
      pinned: true,
      elevation: 0,
      stretch: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: _buildCircleIcon(Icons.arrow_back_ios_new,
                  () => Navigator.of(context).pop()),
        ),
      ),
      actions: [
        _buildCircleIcon(Icons.bookmark_border, () {}),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.shopping_cart_outlined, () {}),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius:
          const BorderRadius.vertical(bottom: Radius.circular(40)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    product.images[index].url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey),
                      );
                    },
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: product.images.length,
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Color(0xFFCCF656),
                      dotColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        stretchModes: const [StretchMode.zoomBackground],
      ),
    );
  }

  Widget _buildTitlePriceAndRating() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF121111),
                  height: 1.3),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                          text: '5.0 ',
                          style:
                          TextStyle(color: Color(0xFF787676), fontSize: 12)),
                      TextSpan(
                        text: '(${product.viewCount ?? 0} reviews)',
                        style: const TextStyle(
                            color: Color(0xFF347EFB), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            '${product.price} ₹',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF292526)),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description,
      style: const TextStyle(
          fontSize: 12, color: Color(0xFF787676), height: 1.5),
    );
  }


Widget _buildSizeSelector() {
    // Fixed order of sizes
    final List<String> sizes = ["XS", "S", "M", "L", "XL", "XXL"];

    // Auto-select based on product.size from API
    if (_selectedSizeIndex == -1 && product.size != null) {
      final initialIndex =
      sizes.indexWhere((s) => s.toLowerCase() == product.size!.toLowerCase());
      if (initialIndex != -1) {
        _selectedSizeIndex = initialIndex;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Size',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(sizes.length, (index) {
            final isSelected = _selectedSizeIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedSizeIndex = index),
              child: Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF292526) : Colors.transparent,
                  border: Border.all(color: const Color(0xFFDFDEDE)),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    sizes[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF292526),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
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
    // Map of color names -> actual Flutter Color
    final Map<String, Color> colorMap = {
      "Grey": const Color(0xFF787676),
      "Dark Grey": const Color(0xFF433F40),
      "Red": const Color(0xFFFF7979),
      "Orange": const Color(0xFFFFB979),
      "Green": const Color(0xFFB7FF79),
      "Sky Blue": const Color(0xFF79E6FF),
      "Blue": const Color(0xFF798BFF),
      "Purple": const Color(0xFFA579FF),
      "Pink": const Color(0xFFFF79F1),
      "Dark Red": const Color(0xFFE10E12),
    };

    final List<String> colorNames = colorMap.keys.toList();
    final List<Color> colors = colorMap.values.toList();

    // Auto-select if product.color matches
    if (_selectedColorIndex == -1 && product.color != null) {
      final initialIndex = colorNames.indexWhere(
            (c) => c.toLowerCase() == product.color!.toLowerCase(),
      );
      if (initialIndex != -1) {
        _selectedColorIndex = initialIndex;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(colors.length, (index) {
              final isSelected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                      isSelected ? const Color(0xFF433F40) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: colors[index],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTabs() {
    return Column(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2EE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            dividerColor: Colors.transparent,
            indicatorPadding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Basic Info'),
              Tab(text: 'Comments(113)'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        SizedBox(
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
        children: [
          const Text("Info", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(product.info1.toString(),
            maxLines: _showAllInfo ? null : 2,
            overflow: _showAllInfo ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          const Text("info2", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "${product.info2}",
            maxLines: _showAllInfo ? null : 2,
            overflow: _showAllInfo ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  Widget _buildCommunityTab() {
    final List<Comment> comments = [
      Comment(
        userName: "Erenyaeger",
        userAvatar: "https://placehold.co/45x45",
        text: "It looks very refreshing ☺️",
        timeAgo: "12 h",
        likes: 3,
      ),
      Comment(
        userName: "Yalenanam",
        userAvatar: "https://placehold.co/45x45",
        text: "You seem to be having fun 🔥",
        timeAgo: "8 h",
        likes: 21,
      ),
      Comment(
        userName: "Edanorman",
        userAvatar: "https://placehold.co/45x45",
        text: "I love this so much! Slay king.",
        timeAgo: "8 h",
        likes: 21,
      ),
    ];

    final displayCount = _showAllCommunity ? comments.length : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCount,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return CommentWidget(comment: comments[index]);
          },
        ),

        if (!_showAllCommunity)
          GestureDetector(
            onTap: () => setState(() => _showAllCommunity = true),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "View all",
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ),
      ],
    );
  }


  Widget _buildReviewsTab() {
    final displayCount = _showAllReviews ? reviews.length : 2;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: displayCount,
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
                          Text(review.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                                  (starIndex) => Icon(
                                starIndex < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment,
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (!_showAllReviews)
          GestureDetector(
            onTap: () => setState(() => _showAllReviews = true),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("View all", style: TextStyle(color: Colors.blue)),
            ),
          ),
      ],
    );
  }

  Widget _buildProductSection(String title, List<Product> products) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
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
      width: 159,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (product.images.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    product.images.first.url, // Use product image
                    height: 177,
                    width: 159,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 177,
                      width: 159,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 42,
                  height: 44,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFBBF711),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '56%\nOFF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF272727)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF272727)),
                ),
                const Divider(color: Color(0xFFDDDDDD), height: 16),
                Text(
                  '${product.stock ?? 0} sold this week',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF249B3E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Policies", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_shipping_outlined, color: Colors.black),
            title: const Text("Free Flat Rate Shipping", style: TextStyle(fontSize: 14)),
            subtitle: const Text("Estimated to be delivered on 09/11/2021 - 12/11/2021.", style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
            children: const [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about free flat rate shipping."))],
          ),
        ),
        const Divider(color: Color(0x33555555)),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: const ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: Icon(Icons.money_off_csred_outlined, color: Colors.black),
            title: Text("COD Policy", style: TextStyle(fontSize: 14)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about our Cash On Delivery policy."))],
          ),
        ),
        const Divider(color: Color(0x33555555)),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: const ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: Icon(Icons.assignment_return_outlined, color: Colors.black),
            title: Text("Return Policy", style: TextStyle(fontSize: 14)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Details about our return policy."))],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF249B3E)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Zatch', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF249B3E)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text('Buy', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 45.21,
            height: 45.21,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.62),
              image: DecorationImage(
                image: NetworkImage(comment.userAvatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + comment + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${comment.userName}  ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: comment.text,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.80),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6.56),
                Row(
                  children: [
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.30),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.24,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      '${comment.likes} likes',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.30),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.24,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      'Reply',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.30),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
