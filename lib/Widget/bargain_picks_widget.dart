import 'package:flutter/material.dart';
import 'package:zatch_app/Widget/reel_screen.dart';
import '../controller/bargain_pick_controller.dart';

class BargainPicksWidget extends StatefulWidget {
  const BargainPicksWidget({super.key});

  @override
  State<BargainPicksWidget> createState() => _BargainPicksWidgetState();
}

class _BargainPicksWidgetState extends State<BargainPicksWidget> {
  final BargainPickController _controller = BargainPickController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const Text(
                  'Bargain Picks For You "Zatching Now"',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_controller.picks.isNotEmpty) {
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReelListScreen(controller: _controller),
                      ),
                    );*/
                  }
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _controller.picks.map((pick) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReelScreen(pick: pick),
                          ),
                        );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.grey.shade300,
                              ),
                              child: const Icon(Icons.video_library, size: 40, color: Colors.black54),
                            ),
                            Container(
                              width: 150,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.black26,
                              ),
                              child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(pick.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(pick.subtitle, style: const TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
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
