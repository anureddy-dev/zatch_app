import 'package:flutter/material.dart';
import 'package:zatch_app/controller/top_pick_controller.dart';
import 'package:zatch_app/model/product_response.dart';

class TopPicksThisWeekWidget extends StatefulWidget {
  const TopPicksThisWeekWidget({super.key});

  @override
  State<TopPicksThisWeekWidget> createState() => _TopPicksThisWeekWidgetState();
}

class _TopPicksThisWeekWidgetState extends State<TopPicksThisWeekWidget> {
  final TopPickController _controller = TopPickController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopPicks();
  }

  Future<void> _loadTopPicks() async {
    try {
      await _controller.fetchTopPicks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load products: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Top Picks This Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Product List
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.topPicks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final Product pick = _controller.topPicks[index];
                final imgUrl = pick.images.isNotEmpty
                    ? pick.images.first.url
                    : "https://via.placeholder.com/150";

                return Container(
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Product Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          imgUrl,
                          width: 180,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// Details Section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title
                            Text(
                              pick.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            /// Price
                            Text(
                              '${pick.price} ₹',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),

                            /// Subtitle (category name if available)
                            Text(
                              pick.category?.name ?? "General",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}
