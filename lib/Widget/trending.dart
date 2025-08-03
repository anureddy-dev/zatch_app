import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title row
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [

              Text(
                "Trending",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "See All",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        // Product Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
            children: const [
              TrendingCard(
                mediaPath: 'assets/images/pic2.png',
                isVideo: false,
                title: 'Modern Light Clothes',
                category: 'Sneakers',
                price: '212.99₹',
                rating: '5.0',
                isLive: true,
              ),
              TrendingCard(
                mediaPath: 'assets/images/img3.png',
                isVideo: false,
                title: 'Light Dress Bless',
                category: 'Dress modern',
                price: '\$162.99',
                rating: '5.0',
              ),
              TrendingCard(
                mediaPath: 'assets/images/vid6.mp4',
                isVideo: true,
                title: 'Maroon Dark',
                category: 'Dress',
              ),
              TrendingCard(
                mediaPath: 'assets/images/img2.png',
                isVideo: false,
                title: 'Yellow Dress',
                isLive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrendingCard extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;
  final String title;
  final String category;
  final String price;
  final String rating;
  final bool isLive;

  const TrendingCard({
    super.key,
    required this.mediaPath,
    this.isVideo = false,
    required this.title,
    this.category = '',
    this.price = '',
    this.rating = '',
    this.isLive = false,
  });

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.asset(widget.mediaPath)
        ..initialize().then((_) {
          _controller?.setLooping(true);
          _controller?.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: widget.isVideo
              ? (_controller != null && _controller!.value.isInitialized)
              ? GestureDetector(
            onTap: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
                if (!_controller!.value.isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 50,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          )
              : Container(
            color: Colors.black12,
            child:
            const Center(child: CircularProgressIndicator()),
          )
              : Image.asset(
            widget.mediaPath,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        if (widget.isLive)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFB7DF4B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Live • 465',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: const Icon(Icons.favorite_border, size: 16),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(widget.category,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
                if (widget.price.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        widget.price,
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star,
                          color: Colors.amber, size: 14),
                      Text(widget.rating,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
