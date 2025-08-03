class Follower {
  final String name;
  final String category;
  final String imageAsset;
  bool isFollowing;

  Follower(this.name, this.category, this.imageAsset, {this.isFollowing = false});
}