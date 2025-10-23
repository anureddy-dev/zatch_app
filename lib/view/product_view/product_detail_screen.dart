import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zatch_app/Widget/bargain_picks_widget.dart';
import 'package:zatch_app/Widget/top_picks_this_week_widget.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/rate_order_dialog.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';

import '../setting_view/profile_screen.dart';


class AllReviewsScreen extends StatelessWidget {
  final List<Review> reviews;
  const AllReviewsScreen({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Reviews")),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                        children: List.generate(
                          5,
                              (starIndex) => Icon(
                            starIndex < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
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
      ),
    );
  }
}

class AllCommentsScreen extends StatelessWidget {
  final List<Comment> comments;
  const AllCommentsScreen({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Comments")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: comments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return CommentWidget(comment: comments[index]);
        },
      ),
    );
  }
}
// endregion

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

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  UserProfileResponse? userProfile;

  final _pageController = PageController();
  late final TabController _tabController;
  int _selectedSizeIndex = -1;
  int _selectedColorIndex = -1;
  final ApiService _apiService = ApiService();

  bool loading = true;
  String? errorMessage;
  late Product product;
  List<Product> similarProducts = [];
  bool _showAllCommunity = false;
  bool _showAllReviews = false;

  final List<Review> reviews = List.generate(
    15,   (i) => Review(
        userName: 'User ${i + 1}',
        userAvatarUrl: 'https://randomuser.me/api/portraits/${i % 2 == 0 ? "women" : "men"}/${i + 1}.jpg',
        rating: (i % 3) + 3,
        comment: 'This is review number ${i + 1}. The product is great!'),
  );

  final List<Comment> comments = List.generate(
    20,   (i) => Comment(
      userName: "UserCommenter${i + 1}",
      userAvatar: "https://randomuser.me/api/portraits/thumb/${i % 2 == 0 ? "men" : "women"}/${i + 20}.jpg",
      text: "This is comment number ${i + 1}.",
      timeAgo: "${i + 1}h",
      likes: (i + 1) * 2,
    ),
  );

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildTitlePriceAndRating(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDescription(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSizeSelector(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildColorSelector(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildInfoTabs(),
                ),
                TopPicksThisWeekWidget(title: "Similar products",showSeeAll: false,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildPolicySection(),
                ),
                TopPicksThisWeekWidget(title: "Products from this seller",showSeeAll: false,),
                const SizedBox(height: 32),
                const BargainPicksWidget(),
                const SizedBox(height: 16),
              ],
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
          child: _buildCircleIcon(Icons.arrow_back_ios_new, () => Navigator.of(context).pop()),
        ),
      ),
      actions: [
        _buildCircleIcon(Icons.bookmark_border, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to Saved Items!")));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(userProfile),
            ),
          );
        }),
        const SizedBox(width: 8),
        _buildCircleIcon(Icons.shopping_cart_outlined, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartScreen(),
            ),
          );
        }),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: product.images.isNotEmpty ? product.images.length : 1,
                itemBuilder: (context, index) {
                  if (product.images.isEmpty) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  }
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
                        child: const Icon(Icons.broken_image, color: Colors.grey),
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
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.6)],
                  ),
                ),
              ),
              if (product.images.length > 1)
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF121111),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      _tabController.animateTo(2);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '5.0 ',
                            style: TextStyle(color: Color(0xFF787676), fontSize: 12),
                          ),
                          TextSpan(
                            text: '(${reviews.length} reviews)',
                            style: const TextStyle(
                              color: Color(0xFF347EFB),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '${product.price} ₹',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF292526),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description,
      style: const TextStyle(fontSize: 12, color: Color(0xFF787676), height: 1.5),
    );
  }

  Widget _buildSizeSelector() {
    final List<String> sizes = ["XS", "S", "M", "L", "XL", "XXL"];
    if (_selectedSizeIndex == -1 && product.size != null) {
      final initialIndex = sizes.indexWhere((s) => s.toLowerCase() == product.size!.toLowerCase());
      if (initialIndex != -1) {
        _selectedSizeIndex = initialIndex;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose Size', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
    final Map<String, Color> colorMap = {
      "Grey": const Color(0xFF787676), "Dark Grey": const Color(0xFF433F40), "Red": const Color(0xFFFF7979),
      "Orange": const Color(0xFFFFB979), "Green": const Color(0xFFB7FF79), "Sky Blue": const Color(0xFF79E6FF),
      "Blue": const Color(0xFF798BFF), "Purple": const Color(0xFFA579FF), "Pink": const Color(0xFFFF79F1),
      "Dark Red": const Color(0xFFE10E12),
    };
    final List<String> colorNames = colorMap.keys.toList();
    final List<Color> colors = colorMap.values.toList();
    if (_selectedColorIndex == -1 && product.color != null) {
      final initialIndex = colorNames.indexWhere((c) => c.toLowerCase() == product.color!.toLowerCase());
      if (initialIndex != -1) {
        _selectedColorIndex = initialIndex;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
                    border: Border.all(color: isSelected ? const Color(0xFF433F40) : Colors.transparent, width: 2),
                  ),
                  child: CircleAvatar(radius: 13, backgroundColor: colors[index]),
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
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            dividerColor: Colors.transparent,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              const Tab(text: 'Basic Info'),
              Tab(text: 'Comments (${comments.length})'), // Shows full number
              Tab(text: 'Reviews (${reviews.length})'), // Shows full number
            ],
          ),
        ),
        SizedBox(
           child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300), // Adjust as needed
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(),
                _buildCommunityTab(),
                _buildReviewsTab(),
              ],
            ),
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
          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(product.info1.toString()),
          const SizedBox(height: 16),
          const Text("Additional Information", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(product.info2.toString()),
        ],
      ),
    );
  }

  Widget _buildCommunityTab() {
    final bool canExpand = comments.length <= 10;
    final displayCount = _showAllCommunity ? comments.length : (comments.length > 2 ? 2 : comments.length);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
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
          // CORRECTED LOGIC: Show "View all" if there are more than 2 comments and the list is not already expanded.
          if (comments.length > 2 && !_showAllCommunity)
            GestureDetector(
              onTap: () {
                // If the total count is 10 or less, expand in place.
                if (canExpand) {
                  setState(() => _showAllCommunity = true);
                } else {
                  // Otherwise, navigate to the new screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllCommentsScreen(comments: comments),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: Text("View all", style: TextStyle(color: Colors.blue, fontSize: 14))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final bool canExpand = reviews.length <= 10;
    final displayCount = _showAllReviews ? reviews.length : (reviews.length > 2 ? 2 : reviews.length);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showReviewDialog(context, product);
              },
              icon: const Icon(Icons.rate_review_outlined,color: Colors.black,),
              label: const Text("Add a Review",style: TextStyle(color: Colors.black),),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayCount,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(review.userAvatarUrl), radius: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (starIndex) =>
                                Icon(starIndex < review.rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 16)),
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
          ),
          // CORRECTED LOGIC: Show "View all" if there are more than 2 reviews and the list is not already expanded.
          if (reviews.length > 2 && !_showAllReviews)
            GestureDetector(
              onTap: () {
                // If the total count is 10 or less, expand in place.
                if (canExpand) {
                  setState(() => _showAllReviews = true);
                } else {
                  // Otherwise, navigate to the new screen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AllReviewsScreen(reviews: reviews)),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text("View all", style: TextStyle(color: Colors.blue))),
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
            subtitle: const Text("Estimated to be delivered on 09/11/2021 - 12/11/2021.",
                style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
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
              // ✅ FIX: Zatch button is now clickable
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Zatch button clicked!")));
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF249B3E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text('Zatch', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final CartItem itemToPurchase = CartItem(
                  name: product.name,
                  price: product.price,
                  quantity: 1,
                  imageUrl: product.images.isNotEmpty ? product.images.first.url : '',
                  description: product.description,  );
                final List<CartItem> itemsForCheckout = [itemToPurchase];
                final double totalPrice = product.price;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutOrPaymentsScreen(
                      isCheckout: true,
                      selectedItems: itemsForCheckout,
                      itemsTotalPrice: totalPrice,
                      subTotalPrice: totalPrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF249B3E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0),
              child: const Text('Buy Now', style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ FIX: User profile pictures now load from network
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(comment.userAvatar),
            onBackgroundImageError: (e, s) => const Icon(Icons.person), // Fallback
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${comment.userName}  ', style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
                      TextSpan(text: comment.text, style: TextStyle(color: Colors.black.withOpacity(0.80), fontSize: 14, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(height: 6.56),
                Row(
                  children: [
                    Text(comment.timeAgo, style: TextStyle(color: Colors.black.withOpacity(0.30), fontSize: 12, fontWeight: FontWeight.w400)),
                    const SizedBox(width: 18),
                    Text('${comment.likes} likes', style: TextStyle(color: Colors.black.withOpacity(0.30), fontSize: 12, fontWeight: FontWeight.w400)),
                    const SizedBox(width: 18),
                    Text('Reply', style: TextStyle(color: Colors.black.withOpacity(0.30), fontSize: 12, fontWeight: FontWeight.w400)),
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
