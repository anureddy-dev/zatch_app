

import '../model/live_follower_model.dart';

class LiveFollowerController {
  List<LiveFollower> followers = [
    LiveFollower('Samera', 'Fashion', 'assets/images/img1.png'),
    LiveFollower('Rajeev', 'Fashion', 'assets/images/img2.png'),
    LiveFollower('Rajeev', 'Fashion', 'assets/images/img3.png'),
  ];

  void addFollower(LiveFollower follower) {
    followers.add(follower);
  }
}