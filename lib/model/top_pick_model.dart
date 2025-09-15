class TopPick {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final String? videoAsset;
  final double price;
  final int? discountPercent;
  final double rating;
  bool isLiked;

  TopPick(
      this.title,
      this.subtitle,
      this.imageAsset, {
        this.videoAsset,
        this.price = 0.0,
        this.discountPercent,
        this.rating = 0.0,
        this.isLiked = false,
      });
}
