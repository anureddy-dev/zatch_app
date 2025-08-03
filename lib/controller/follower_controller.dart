

import '../model/follower_model.dart';

class FollowerController {
  List<Follower> followers = [
    Follower('Samera', 'Fashion', 'assets/images/img1.png'),
    Follower('Rajeev', 'Fashion', 'assets/images/img2.png'),
    Follower('Priya', 'Tech', 'assets/images/img3.png'),
    Follower('Samera', 'Fashion', 'assets/images/img1.png'),
    Follower('Rajeev', 'Fashion', 'assets/images/img2.png'),
    Follower('Priya', 'Tech', 'assets/images/img3.png'),
  ];

  void toggleFollow(int index) {
    followers[index].isFollowing = !followers[index].isFollowing;
  }

  void addFollower(Follower follower) {
    followers.add(follower);
  }
}