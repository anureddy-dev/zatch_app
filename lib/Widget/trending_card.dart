import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zatch_app/model/bit_response.dart';

class TrendingCard extends StatefulWidget {
  final Bit bit;

  const TrendingCard({super.key, required this.bit});

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.bit.isVideo) {
      _controller = VideoPlayerController.network(widget.bit.mediaPath)
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
          borderRadius: BorderRadius.circular(16),
          child: widget.bit.isVideo
              ? (_controller != null && _controller!.value.isInitialized
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
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          )
              : Container(
            color: Colors.black12,
            child: const Center(child: CircularProgressIndicator()),
          ))
              : Image.network(
            widget.bit.mediaPath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (widget.bit.liveStatus)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFBBF711),
                borderRadius: BorderRadius.circular(48),
              ),
              child: Text(
                'Live',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
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
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bit.displayTitle,
                    style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(widget.bit.displayCategory,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                if (widget.bit.displayPrice.isNotEmpty)
                  Row(
                    children: [
                      Text(widget.bit.displayPrice,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(widget.bit.displayRating,
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
