class Product {
  final String name;
  final String category;
  final String price;
  final String imageUrl;
  final String discount;
  final int soldCount;
  bool isWishlisted;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.discount,
    required this.soldCount,
    this.isWishlisted = false,
  });
}
class Review {
  final String userName;
  final String userAvatarUrl;
  final int rating;
  final String comment;

  Review({
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
  });
}