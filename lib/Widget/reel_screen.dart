import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:zatch_app/model/bargain_pick_model.dart';

class ReelScreen extends StatefulWidget {
  final BargainPick pick;

  const ReelScreen({super.key, required this.pick});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.pick.videoAsset)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// Background Video
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),

          /// Top Profile Bar
          Positioned(
            top: 60,
            left: 16,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage("assets/profile.jpg"), // dynamic
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pick.productTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text("5.0", style: TextStyle(color: Colors.white, fontSize: 12)),
                        SizedBox(width: 10),
                        Icon(Icons.people, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text("32K", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),

          /// Right Action Buttons
          Positioned(
            right: 16,
            bottom: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: const [
                    Icon(Icons.favorite, color: Colors.white, size: 32),
                    SizedBox(height: 4),
                    Text("4.2k", style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 20),
                const Icon(Icons.bookmark, color: Colors.white, size: 30),
                const SizedBox(height: 20),
                const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
              ],
            ),
          ),

          /// Bottom Product Card
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Product",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage("assets/product.jpg"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Modern light clothes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "212.99 ₹",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _buildButton("Zatch"),
                          const SizedBox(width: 10),
                          _buildButton("Buy"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
