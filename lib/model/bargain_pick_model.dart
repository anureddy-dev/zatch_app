class BargainPick {
  final String title;
  final String subtitle;
  final String? imageAsset; // Optional image
  final String? videoAsset; // Optional video

  BargainPick(this.title, this.subtitle, {this.imageAsset, this.videoAsset});
}