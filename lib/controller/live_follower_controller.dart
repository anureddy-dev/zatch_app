import '../model/live_follower_model.dart';

class LiveFollowerController {
  List<LiveFollowerModel> liveUsers = [
    LiveFollowerModel(
      name: "Jemma Ray",
      image: "https://picsum.photos/300/400?random=1",
      category: "Fashion",
      viewers: 4200,
      rating: 5.0,
      followers: 32000,
    ),
    LiveFollowerModel(
      name: "Ankitha Lauren",
      image: "https://picsum.photos/300/400?random=2",
      category: "Travel",
      viewers: 3100,
      rating: 4.8,
      followers: 28000,
    ),
    LiveFollowerModel(
      name: "David Chen",
      image: "https://picsum.photos/300/400?random=3",
      category: "Tech",
      viewers: 2700,
      rating: 4.7,
      followers: 15000,
    ),
  ];
}
