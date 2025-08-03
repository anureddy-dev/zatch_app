class TopPick {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? videoAsset;
  final double price;
  final int? discountPercent;
  bool isLiked;

  TopPick(
      this.title,
      this.subtitle,
      this.imageAsset, {
        this.videoAsset,
        this.price = 0.0,
        this.discountPercent,
        this.isLiked = false,
      });
}
