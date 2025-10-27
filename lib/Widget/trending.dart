import 'package:flutter/material.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/TrendingBit.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/ReelDetailsScreen.dart';
import 'package:zatch_app/view/live_view/see_all_live_screen.dart';
import 'package:zatch_app/view/reel/AllTrendingScreen.dart';

class TrendingSection extends StatefulWidget {
  const TrendingSection({super.key});

  @override
  State<TrendingSection> createState() => _TrendingSectionState();
}

class _TrendingSectionState extends State<TrendingSection> {
  late Future<List<TrendingBit>> trendingFuture;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    trendingFuture = _api.fetchTrendingBits();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrendingBit>>(
      future: trendingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No trending items"));
        }

        final bits = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Trending",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllTrendingScreen()),
                      );
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              itemCount: bits.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 320,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return TrendingCard(bit: bits[index]);
              },
            ),
          ],
        );
      },
    );
  }
}

class TrendingCard extends StatefulWidget {
  final TrendingBit bit;  const TrendingCard({super.key, required this.bit});

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  late bool isLiked;
  late int likeCount;
  bool isApiCallInProgress = false;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    likeCount = widget.bit.likeCount;
    isLiked = likeCount > 0;
  }

  Future<void> _toggleLike() async {
    if (isApiCallInProgress) return;

    setState(() {
      isApiCallInProgress = true;
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }
    });

    try {
      final newServerLikeCount = await _api.toggleLike(widget.bit.id);
      widget.bit.likeCount = newServerLikeCount;
      setState(() {
        likeCount = newServerLikeCount;
        isLiked = newServerLikeCount > 0;
      });

    } catch (e) {
      setState(() {
        isLiked = !isLiked;
        if (isLiked) {
          likeCount++;
        } else {
          likeCount--;
        }
      });
      debugPrint("Failed to toggle like: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Action failed. Please try again."), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isApiCallInProgress = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.bit.isLive == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const SeeAllLiveScreen(
                  liveSessions: [],
                )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    ReelDetailsScreen(bitId:widget.bit.id ?? '', controller: LiveStreamController())), // use actual id
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.bit.thumbnailUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error)),
                      );
                    },
                  ),
                  if (widget.bit.isLive == true)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBBF711),
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleLike,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: isApiCallInProgress
                            ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Icon(
                          // The icon is determined by the 'isLiked' state variable
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bit.title ?? 'Untitled',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Encode Sans',
                      ),
                    ),
                    Text(
                      widget.bit.description ?? 'No category',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontFamily: 'Encode Sans',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.bit.viewCount ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Encode Sans',
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              widget.bit.viewCount?.toString() ?? '0.0',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Encode Sans',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
