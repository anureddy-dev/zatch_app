import 'package:zatch_app/model/bargain_pick_model.dart';

class BargainPickController {
  final List<BargainPick> picks = [
    BargainPick(
      title: 'Modern Clothes',
      subtitle: 'Zatch from less than 150',
      videoAsset: 'assets/videos/vid1.mp4',
      productTitle: 'Modern light clothes',
      productPrice: '212.99 ₹',
      thumbnail: 'assets/images/vid1_thumb.jpg', // add thumbnail
    ),
    BargainPick(
      title: 'Trendy Jackets',
      subtitle: 'Zatch winter fits',
      videoAsset: 'assets/videos/vid2.mp4',
      productTitle: 'Winter Jacket',
      productPrice: '499.99 ₹',
      thumbnail: 'assets/images/vid2_thumb.jpg',
    ),
    BargainPick(
      title: 'Streetwear',
      subtitle: 'Zatch budget tees',
      videoAsset: 'assets/videos/vid3.mp4',
      productTitle: 'Casual Streetwear Tee',
      productPrice: '199.99 ₹',
      thumbnail: 'assets/images/vid3_thumb.jpg',
    ),
    BargainPick(
      title: 'Accessories',
      subtitle: 'Zatch from 99 only',
      videoAsset: 'assets/videos/vid4.mp4',
      productTitle: 'Stylish Watch',
      productPrice: '99.99 ₹',
      thumbnail: 'assets/images/vid4_thumb.jpg',
    ),
  ];

  void addPick(BargainPick pick) {
    picks.add(pick);
  }
}
