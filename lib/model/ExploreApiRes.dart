// You can put these in a separate file, e.g., models/explore_response.dart
import 'package:flutter/foundation.dart'; // For @required or required keyword

// Model for the main response structure
class ExploreApiResponse {
  final bool success;
  final String message;
  final List<Bits> bits;

  ExploreApiResponse({
    required this.success,
    required this.message,
    required this.bits,
  });

  factory ExploreApiResponse.fromJson(Map<String, dynamic> json) {
    var bitsListFromJson = json['bits'] as List<dynamic>?; // Handle null case
    List<Bits> parsedBits = [];
    if (bitsListFromJson != null) {
      parsedBits = bitsListFromJson.map((i) => Bits.fromJson(i as Map<String, dynamic>)).toList();
    }

    return ExploreApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      bits: parsedBits,
    );
  }
}

// Your existing Bit model (or a refined version)
// Ensure Bit.fromJson is correctly implemented as discussed before
class Bits {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String userId;
  final List<String> likes; // Or a more complex Like object if needed
  final int likeCount;
  final int viewCount;
  final String shareLink;
  final DateTime createdAt;
  // Add other fields like shareCount if necessary

  Bits({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.userId,
    required this.likes,
    required this.likeCount,
    required this.viewCount,
    required this.shareLink,
    required this.createdAt,
  });

  factory Bits.fromJson(Map<String, dynamic> json) {
    // Safely access nested 'url'
    String url = '';
    if (json['video'] != null && json['video']['url'] != null) {
      url = json['video']['url'] as String;
    }

    return Bits(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: url,
      userId: json['userId'] as String,
      likes: List<String>.from(json['likes'] as List<dynamic>),
      likeCount: json['likeCount'] as int? ?? 0, // Handle potential null or missing
      viewCount: json['viewCount'] as int? ?? 0, // Handle potential null or missing
      shareLink: json['shareLink'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
