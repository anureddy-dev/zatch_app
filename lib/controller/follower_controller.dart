import 'package:zatch_app/services/api_service.dart';
import '../model/follower_model.dart';

class FollowerController {
  final ApiService _api = ApiService();

  List<Follower> followers = [
    Follower("Samera", "Fashion",
        "https://randomuser.me/api/portraits/women/44.jpg",
        id: "6898ae8836e67718f8f1f626"),
    Follower("Rajeev", "Fashion",
        "https://randomuser.me/api/portraits/men/46.jpg",
        id: "6898ae8836e67718f8f1f627"),
    Follower("Priya", "Tech",
        "https://randomuser.me/api/portraits/women/65.jpg",
        id: "68988ae8836e67718f8f1f62"),

  ];

  Future<void> toggleFollow(int index) async {
    final follower = followers[index];
    try {
      final res = await _api.toggleFollowUser(follower.id);
      final newIsFollowing = !follower.isFollowing;
      print("Toggled follow: ${res.message}, now following: $newIsFollowing");
      followers[index] = follower.copyWith(isFollowing: newIsFollowing);
    } catch (e) {
      print("Toggle follow failed: $e");
    }
  }
}
