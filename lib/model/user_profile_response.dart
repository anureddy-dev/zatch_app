class UserProfileResponse {
  final bool success;
  final String message;
  final User user;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user.toJson(),
    };
  }
}

class User {
  final String id;
  final String username;
  final String countryCode;
  final String phone;
  final String email;
  final String? dob;
  final String gender;
  final String password;
  final ProfilePic profilePic;
  final List<dynamic> followers;
  final List<dynamic> following;
  final int followerCount;
  final int reviewsCount;
  final int productsSoldCount;
  final int customerRating;
  final List<dynamic> savedBits;
  final List<dynamic> savedProducts;
  final DateTime createdAt;
  final List<dynamic> sellingProducts;
  final List<dynamic> upcomingLives;

  User({
    required this.id,
    required this.username,
    required this.countryCode,
    required this.phone,
    required this.dob,
    required this.email,
    required this.gender,
    required this.password,
    required this.profilePic,
    required this.followers,
    required this.following,
    required this.followerCount,
    required this.reviewsCount,
    required this.productsSoldCount,
    required this.customerRating,
    required this.savedBits,
    required this.savedProducts,
    required this.createdAt,
    required this.sellingProducts,
    required this.upcomingLives,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      countryCode: json['countryCode'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '',
      profilePic: ProfilePic.fromJson(json['profilePic'] ?? {}),
      followers: List<dynamic>.from(json['followers'] ?? []),
      following: List<dynamic>.from(json['following'] ?? []),
      followerCount: json['followerCount'] ?? 0,
      reviewsCount: json['reviewsCount'] ?? 0,
      productsSoldCount: json['productsSoldCount'] ?? 0,
      customerRating: json['customerRating'] ?? 0,
      savedBits: List<dynamic>.from(json['savedBits'] ?? []),
      savedProducts: List<dynamic>.from(json['savedProducts'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      sellingProducts: List<dynamic>.from(json['sellingProducts'] ?? []),
      upcomingLives: List<dynamic>.from(json['upcomingLives'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'countryCode': countryCode,
      'phone': phone,
      'email': email,
      'dob': dob,
      'gender': gender,
      'password': password,
      'profilePic': profilePic.toJson(),
      'followers': followers,
      'following': following,
      'followerCount': followerCount,
      'reviewsCount': reviewsCount,
      'productsSoldCount': productsSoldCount,
      'customerRating': customerRating,
      'savedBits': savedBits,
      'savedProducts': savedProducts,
      'createdAt': createdAt.toIso8601String(),
      'sellingProducts': sellingProducts,
      'upcomingLives': upcomingLives,
    };
  }
}

class ProfilePic {
  final String publicId;
  final String url;

  ProfilePic({
    required this.publicId,
    required this.url,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) {
    return ProfilePic(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }
}
