import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';

import '../view/product_view/see_all_top_picks_screen.dart';

class TopPicksThisWeekWidget extends StatefulWidget {
  final String? title;
  final bool showSeeAll;
  const TopPicksThisWeekWidget({super.key, this.title,
    this.showSeeAll = true,

  });

  @override
  State<TopPicksThisWeekWidget> createState() => _TopPicksThisWeekWidgetState();
}

class _TopPicksThisWeekWidgetState extends State<TopPicksThisWeekWidget> {
  final ApiService _apiService = ApiService();
  bool loading = true;
  List<Product> topPicks = [];

  @override
  void initState() {
    super.initState();
    _loadTopPicks();
  }

  Future<void> _loadTopPicks() async {
    setState(() => loading = true);
    try {
      topPicks = await _apiService.getTopPicks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load products: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String formatPrice(num price) =>
      NumberFormat.currency(locale: 'en_US', symbol: "\$").format(price);

  String formatSold(num sold) =>
      NumberFormat.decimalPattern().format(sold);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Show only top 3 products
    final displayList = topPicks.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                widget.title ?? 'Top Picks This Week',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.showSeeAll)
              GestureDetector(
                onTap: () {
                  if (topPicks.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllTopPicksScreen(products: topPicks),
                      ),
                    );
                  }
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Product Cards List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 266,
            child: displayList.isEmpty
                ? const Center(
              child: Text(
                "No active top picks available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            )
                : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: displayList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = displayList[index];
                final imgUrl = product.images.isNotEmpty
                    ? product.images.first.url
                    : "https://via.placeholder.com/159x177";

                return GestureDetector(onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen( productId: product.id),
                    ),
                  );
                },
                  child: Container(
                    width: 159,
                    height: 266,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF4F4F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              width: double.infinity,
                              height: 177,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imgUrl),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF272727),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatPrice(product.price),
                                        style: const TextStyle(
                                          color: Color(0xFF272727),
                                          fontSize: 12,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Row(
                                        children: const [
                                          Icon(Icons.star,
                                              size: 14,
                                              color: Colors.amber),
                                          SizedBox(width: 2),
                                          Text(
                                            '5.0',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Encode Sans',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: const Color(0xFFDDDDDD),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${formatSold(product.stock ?? 0)} sold this week',
                                    style: const TextStyle(
                                      color: Color(0xFF249B3E),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFBBF711),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '56% OFF',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
