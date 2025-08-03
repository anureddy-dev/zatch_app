import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../controller/top_pick_controller.dart';

class TopPicksThisWeekWidget extends StatefulWidget {
  const TopPicksThisWeekWidget({super.key});

  @override
  State<TopPicksThisWeekWidget> createState() =>
      _TopPicksThisWeekWidgetState();
}

class _TopPicksThisWeekWidgetState extends State<TopPicksThisWeekWidget> {
  final TopPickController _controller = TopPickController();
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final firstPick = _controller.topPicks.firstWhere(
          (pick) => pick.videoAsset != null,
      orElse: () => _controller.topPicks[0],
    );

    if (firstPick.videoAsset != null) {
      _videoController = VideoPlayerController.asset(firstPick.videoAsset!)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        }).catchError((e) {
          print('Error initializing video: $e');
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(
            height: 280,
            width: double.infinity,
            child: _controller.topPicks.isEmpty
                ? const Center(child: Text('No top picks available'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _controller.topPicks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pick = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: pick.videoAsset != null &&
                                      index == 0 &&
                                      _videoController != null &&
                                      _videoController!.value
                                          .isInitialized
                                      ? VideoPlayer(_videoController!)
                                      : pick.imageAsset != null
                                      ? Image.asset(
                                    pick.imageAsset!,
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                              ),
                              if (pick.discountPercent != null)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFC6F500),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      '${pick.discountPercent}% OFF',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              if (pick.videoAsset != null && index == 0)
                                Positioned.fill(
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        _videoController?.value
                                            .isPlaying ??
                                            false
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: _togglePlayPause,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pick.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${pick.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pick.subtitle,
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
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
