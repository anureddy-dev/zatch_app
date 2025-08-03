// top_pick_controller.dart
import '../model/top_pick_model.dart';

class TopPickController {
  List<TopPick> topPicks = [
    TopPick(
      'Men\'s Harrington Jacket',
      '1,200 sold this week',
      'assets/images/s1.png',
      price: 148.00,
      discountPercent: 56,
      videoAsset: 'assets/watch_video.mp4',
    ),
    TopPick(
      'Max Cirro Men\'s Slides',
      '1,200 sold this week',
      'assets/images/s2.png',
      price: 148.00,
      discountPercent: 56,
    ),
    TopPick(
      'Max Cirro Jacket',
      '1,200 sold this week',
      'assets/images/s3.png',
      price: 148.00,
      discountPercent: 56,
    ),
  ];


  void toggleLike(int index) {
    topPicks[index].isLiked = !topPicks[index].isLiked;
  }

  void addTopPick(TopPick topPick) {
    topPicks.add(topPick);
  }
}