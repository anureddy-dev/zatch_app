class BitsResponse {
  final bool success;
  final String message;
  final List<Bit> bits;

  BitsResponse({
    required this.success,
    required this.message,
    required this.bits,
  });

  factory BitsResponse.fromJson(Map<String, dynamic> json) {
    return BitsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      bits: (json['bits'] as List<dynamic>?)
          ?.map((e) => Bit.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Bit {
  final String id;
  final String title;
  final String description;
  final String userId;
  final List<String> likes;
  final int likeCount;
  final String shareLink;
  final DateTime createdAt;
  final Video video;

  Bit({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.likes,
    required this.likeCount,
    required this.shareLink,
    required this.createdAt,
    required this.video,
  });

  factory Bit.fromJson(Map<String, dynamic> json) {
    return Bit(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      shareLink: json['shareLink'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      video: Video.fromJson(json['video'] ?? {}),
    );
  }
}

class Video {
  final String publicId;
  final String url;

  Video({required this.publicId, required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
