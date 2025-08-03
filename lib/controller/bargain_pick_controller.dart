

import '../model/bargain_pick_model.dart';

class BargainPickController {
  List<BargainPick> picks = [
    BargainPick('Modern Clothes', 'Zatch from less than 150', videoAsset: 'assets/images/vid.mp4'), // Video for the first pick
    BargainPick('Modern Clothes', 'Zatch from less than 150', imageAsset: 'assets/images/pic2.png'),
    BargainPick('Modern Clothes', 'Zatch from less than 150', imageAsset: 'assets/images/pic3.png'),
    BargainPick('Modern Clothes', 'Zatch from less than 150', imageAsset: 'assets/images/pic4.png'),
  ];

  void addPick(BargainPick pick) {
    picks.add(pick);
  }
}