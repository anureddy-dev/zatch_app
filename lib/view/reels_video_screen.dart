// reels_video_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../controller/reels_controller.dart';
import '../widget/video_list_widget.dart';

class ReelsVideoScreen extends StatefulWidget {
  final int initialIndex;
  const ReelsVideoScreen({super.key, required this.initialIndex});

  @override
  State<ReelsVideoScreen> createState() => _ReelsVideoScreenState();
}

class _ReelsVideoScreenState extends State<ReelsVideoScreen> {
  final ReelsController _controller = ReelsController();
  late List<VideoPlayerController> _videoControllers;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initializeVideos();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _initializeVideos() {
    _videoControllers = _controller.reelsVideos.map((video) {
      final ctrl = VideoPlayerController.asset(video.videoAsset);
      ctrl.initialize().then((_) {
        setState(() {});
        if (video.isPlaying) ctrl.play();
      }).catchError((e) {
        print('Error initializing ${video.title}: $e');
      });
      return ctrl;
    }).toList();
  }

  @override
  void dispose() {
    for (var c in _videoControllers) c.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _togglePlayPause(int idx) {
    final ctrl = _videoControllers[idx];
    setState(() {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
        _controller.reelsVideos[idx].isPlaying = false;
      } else {
        ctrl.play();
        _controller.reelsVideos[idx].isPlaying = true;
      }
    });
  }

  void _toggleLike(int idx) {
    setState(() => _controller.toggleLike(idx));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height, // Ensures definite size
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _controller.reelsVideos.length,
          itemBuilder: (_, idx) {
            final video = _controller.reelsVideos[idx];
            final ctrl = _videoControllers[idx];

            return Stack(
              children: [
                Center(
                  child: ctrl.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: ctrl.value.aspectRatio,
                    child: VideoPlayer(ctrl),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => _togglePlayPause(idx),
                    child: AnimatedOpacity(
                      opacity: ctrl.value.isPlaying ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          ctrl.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      video.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: video.isLiked ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _toggleLike(idx),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const VideoListWidget()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('OK', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
