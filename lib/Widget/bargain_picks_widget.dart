import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../controller/bargain_pick_controller.dart';

class BargainPicksWidget extends StatefulWidget {
  const BargainPicksWidget({super.key});

  @override
  State<BargainPicksWidget> createState() => _BargainPicksWidgetState();
}

class _BargainPicksWidgetState extends State<BargainPicksWidget> {
  final BargainPickController _controller = BargainPickController();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(_controller.picks[0].videoAsset!)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Bargain Picks For You "Zatching Now"',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _controller.picks.asMap().entries.map((entry) {
                final index = entry.key;
                final pick = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 150,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              image: pick.imageAsset != null
                                  ? DecorationImage(
                                image: AssetImage(pick.imageAsset!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: pick.videoAsset != null && index == 0
                                ? _videoController.value.isInitialized
                                ? VideoPlayer(_videoController)
                                : const Center(child: CircularProgressIndicator())
                                : null,
                          ),
                          if (pick.videoAsset != null && index == 0)
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  _videoController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: _togglePlayPause,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pick.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pick.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}