class UserProfile {
  final String id;
  final String? username;
  final String? phone;
  final String? email;
  final String? countryCode;
  final String? gender;
  final String? categoryType;
  final String? role;
  final String? profilePicUrl;
  final int followerCount;
  final int reviewsCount;
  final int productsSoldCount;
  final int customerRating;
  final List<dynamic> followers;
  final List<dynamic> following;
  final List<dynamic> sellingProducts;

  UserProfile({
    required this.id,
    this.username,
    this.phone,
    this.email,
    this.countryCode,
    this.gender,
    this.categoryType,
    this.role,
    this.profilePicUrl,
    this.followerCount = 0,
    this.reviewsCount = 0,
    this.productsSoldCount = 0,
    this.customerRating = 0,
    this.followers = const [],
    this.following = const [],
    this.sellingProducts = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    final profilePic = user['profilePic'] ?? {};

    return UserProfile(
      id: user['_id'] ?? '',
      username: user['username'],
      phone: user['phone'],
      email: user['email'],
      countryCode: user['countryCode'],
      gender: user['gender'],
      categoryType: user['categoryType'],
      role: user['role'],
      profilePicUrl: profilePic['url'],
      followerCount: user['followerCount'] ?? 0,
      reviewsCount: user['reviewsCount'] ?? 0,
      productsSoldCount: user['productsSoldCount'] ?? 0,
      customerRating: user['customerRating'] ?? 0,
      followers: user['followers'] ?? [],
      following: user['following'] ?? [],
      sellingProducts: user['sellingProducts'] ?? [],
    );
  }
}
