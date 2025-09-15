
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController videoController;
  final String title;

  const VideoPlayerScreen({super.key, required this.videoController, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    widget.videoController.play();
    print('VideoPlayerScreen initialized for ${widget.title} at ${DateTime.now()}');
  }

  @override
  void dispose() {
    widget.videoController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Full-screen video
          Center(
            child: AspectRatio(
              aspectRatio: widget.videoController.value.aspectRatio,
              child: VideoPlayer(widget.videoController),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Play/Pause button overlay
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (widget.videoController.value.isPlaying) {
                    widget.videoController.pause();
                  } else {
                    widget.videoController.play();
                  }
                });
              },
              child: Center(
                child: AnimatedOpacity(
                  opacity: widget.videoController.value.isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}