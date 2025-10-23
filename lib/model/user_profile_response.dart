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

  @override
  String toString() => 'UserProfileResponse(success: $success, message: $message, user: $user)';
}

class User {
  final String id;
  final String username;
  final String countryCode;
  final String phone;
  final String email;
  final String? dob;
  final String gender;
  final String categoryType;
  final ProfilePic profilePic;
  //final SellerProfile? sellerProfile;
  //final GlobalBargainSettings? globalBargainSettings;
  final List<dynamic> followers;
  final List<dynamic> following;
  final int followerCount;
  final int reviewsCount;
  final int productsSoldCount;
  final int customerRating;
  final List<dynamic> savedBits;
  final List<dynamic> savedProducts;
  final bool isAdmin;
  final DateTime createdAt;
  final String sellerStatus;
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
    required this.categoryType,
    required this.profilePic,
   // required this.sellerProfile,
    //required this.globalBargainSettings,
    required this.followers,
    required this.following,
    required this.followerCount,
    required this.reviewsCount,
    required this.productsSoldCount,
    required this.customerRating,
    required this.savedBits,
    required this.savedProducts,
    required this.isAdmin,
    required this.createdAt,
    required this.sellerStatus,
    required this.sellingProducts,
    required this.upcomingLives,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      countryCode: json['countryCode'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'],
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      categoryType: json['categoryType'] ?? '',
      profilePic: ProfilePic.fromJson(json['profilePic'] ?? {}),
    /*  sellerProfile: json['sellerProfile'] != null
          ? SellerProfile.fromJson(json['sellerProfile'])
          : null,
      globalBargainSettings: json['globalBargainSettings'] != null
          ? GlobalBargainSettings.fromJson(json['globalBargainSettings'])
          : null,*/
      followers: List<dynamic>.from(json['followers'] ?? []),
      following: List<dynamic>.from(json['following'] ?? []),
      followerCount: json['followerCount'] ?? 0,
      reviewsCount: json['reviewsCount'] ?? 0,
      productsSoldCount: json['productsSoldCount'] ?? 0,
      customerRating: json['customerRating'] ?? 0,
      savedBits: List<dynamic>.from(json['savedBits'] ?? []),
      savedProducts: List<dynamic>.from(json['savedProducts'] ?? []),
      isAdmin: json['isAdmin'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      sellerStatus: json['sellerStatus'] ?? '',
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
      'categoryType': categoryType,
      'profilePic': profilePic.toJson(),
      //'sellerProfile': sellerProfile?.toJson(),
      //'globalBargainSettings': globalBargainSettings?.toJson(),
      'followers': followers,
      'following': following,
      'followerCount': followerCount,
      'reviewsCount': reviewsCount,
      'productsSoldCount': productsSoldCount,
      'customerRating': customerRating,
      'savedBits': savedBits,
      'savedProducts': savedProducts,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'sellerStatus': sellerStatus,
      'sellingProducts': sellingProducts,
      'upcomingLives': upcomingLives,
    };
  }

  @override
  String toString() =>
      'User(username: $username, email: $email, followerCount: $followerCount)';
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

  Map<String, dynamic> toJson() => {
    'public_id': publicId,
    'url': url,
  };
}
/*
class SellerProfile {
  final Address? address;
  final BankDetails? bankDetails;
  final String businessName;
  final List<dynamic> documents;
  final String gstin;
  final bool tcAccepted;
  final String shippingMethod;

  SellerProfile({
    required this.address,
    required this.bankDetails,
    required this.businessName,
    required this.documents,
    required this.gstin,
    required this.tcAccepted,
    required this.shippingMethod,
  });

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      bankDetails:
      json['bankDetails'] != null ? BankDetails.fromJson(json['bankDetails']) : null,
      businessName: json['businessName'] ?? '',
      documents: List<dynamic>.from(json['documents'] ?? []),
      gstin: json['gstin'] ?? '',
      tcAccepted: json['tcAccepted'] ?? false,
      shippingMethod: json['shippingMethod'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address?.toJson(),
    'bankDetails': bankDetails?.toJson(),
    'businessName': businessName,
    'documents': documents,
    'gstin': gstin,
    'tcAccepted': tcAccepted,
    'shippingMethod': shippingMethod,
  };
}

*//*class Address {
  final String pickupAddress;
  final String billingAddress;
  final String pinCode;
  final String state;
  final double latitude;
  final double longitude;

  Address({
    required this.pickupAddress,
    required this.billingAddress,
    required this.pinCode,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      pickupAddress: json['pickupAddress'] ?? '',
      billingAddress: json['billingAddress'] ?? '',
      pinCode: json['pinCode'] ?? '',
      state: json['state'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'pickupAddress': pickupAddress,
    'billingAddress': billingAddress,
    'pinCode': pinCode,
    'state': state,
    'latitude': latitude,
    'longitude': longitude,
  };
}*//*

class BankDetails {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;

  BankDetails({
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      upiId: json['upiId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'accountHolderName': accountHolderName,
    'accountNumber': accountNumber,
    'ifscCode': ifscCode,
    'bankName': bankName,
    'upiId': upiId,
  };
}

class GlobalBargainSettings {
  final bool enabled;
  final int autoAcceptDiscount;
  final int maximumDiscount;

  GlobalBargainSettings({
    required this.enabled,
    required this.autoAcceptDiscount,
    required this.maximumDiscount,
  });

  factory GlobalBargainSettings.fromJson(Map<String, dynamic> json) {
    return GlobalBargainSettings(
      enabled: json['enabled'] ?? false,
      autoAcceptDiscount: json['autoAcceptDiscount'] ?? 0,
      maximumDiscount: json['maximumDiscount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'autoAcceptDiscount': autoAcceptDiscount,
    'maximumDiscount': maximumDiscount,
  };
}*/
