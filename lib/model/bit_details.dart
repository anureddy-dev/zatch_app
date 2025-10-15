import 'dart:convert';

// Helper function to decode the JSON response
BitDetailsResponse bitDetailsResponseFromJson(String str) =>
    BitDetailsResponse.fromJson(json.decode(str));

class BitDetailsResponse {
  final bool success;
  final String message;
  final BitDetails bit;

  BitDetailsResponse({
    required this.success,
    required this.message,
    required this.bit,
  });

  factory BitDetailsResponse.fromJson(Map<String, dynamic> json) => BitDetailsResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    bit: BitDetails.fromJson(json["bits"] ?? {}),
  );
}

class BitDetails {
  final Video video;
  final String id;
  final String title;
  final String description;
  final String userId;
  final List<String> likes;
  final int likeCount;
  final int shareCount;
  final int viewCount;
  final String shareLink;
  final DateTime createdAt;

  BitDetails({
    required this.video,
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.likes,
    required this.likeCount,
    required this.shareCount,
    required this.viewCount,
    required this.shareLink,
    required this.createdAt,
  });

  factory BitDetails.fromJson(Map<String, dynamic> json) => BitDetails(
    video: Video.fromJson(json["video"] ?? {}),
    id: json["_id"] ?? "",
    title: json["title"] ?? "No Title",
    description: json["description"] ?? "No Description",
    userId: json["userId"] ?? "",
    likes: json["likes"] == null ? [] : List<String>.from(json["likes"].map((x) => x)),
    likeCount: json["likeCount"] ?? 0,
    shareCount: json["shareCount"] ?? 0,
    viewCount: json["viewCount"] ?? 0,
    shareLink: json["shareLink"] ?? "",
    createdAt:
    json["createdAt"] == null ? DateTime.now() : DateTime.parse(json["createdAt"]),
  );
}

class Video {
  final String publicId;
  final String url;

  Video({
    required this.publicId,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    publicId: json["public_id"] ?? "",
    url: json["url"] ?? "",
  );
}
