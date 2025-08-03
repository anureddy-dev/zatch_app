class LiveFollower {
  final String name;
  final String category;
  final String imageAsset;
  bool isFollowing;

  LiveFollower(this.name, this.category, this.imageAsset, {this.isFollowing = false});
}