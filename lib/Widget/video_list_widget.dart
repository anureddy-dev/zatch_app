import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../controller/video_controller.dar.dart';
import '../view/reels_video_screen.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({super.key});

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  final VideoController _controller = VideoController();
  late List<VideoPlayerController> _videoControllers;

  @override
  void initState() {
    super.initState();
    print('VideoListWidget initialized at ${DateTime.now()}');
    _initializeVideos();
  }

  void _initializeVideos() {
    _videoControllers = _controller.videoItems.map((item) {
      final controller = VideoPlayerController.asset(item.videoAsset);
      controller.initialize().then((_) {
        setState(() {});
        if (item.isPlaying) controller.play();
      }).catchError((e) {
        print('Error initializing video ${item.title}: $e');
      });
      return controller;
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building VideoListWidget');
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Video Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Grid inside fixed-height box to prevent layout error
          SizedBox(
            height: 300, // You can adjust this height as needed
            child: Container(
              color: Colors.blueGrey,
              child: _controller.videoItems.isEmpty
                  ? const Center(child: Text('No videos available'))
                  : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 150 / 250,
                children: _controller.videoItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final video = entry.value;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsVideoScreen(initialIndex: index),
                          ),
                        );
                      },
                      child: _videoControllers[index].value.isInitialized
                          ? VideoPlayer(_videoControllers[index])
                          : const Center(child: CircularProgressIndicator()),
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
