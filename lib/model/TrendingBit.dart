class TrendingBit {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String badge;
  final int likeCount;
  final int viewCount;
  final int shareCount;
  final String shareLink;
  final DateTime createdAt;
  final bool isLive;

  TrendingBit({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.badge,
    required this.likeCount,
    required this.viewCount,
    required this.shareCount,
    required this.shareLink,
    required this.createdAt,
    this.isLive = false,
  });

  factory TrendingBit.fromJson(Map<String, dynamic> json) {
    return TrendingBit(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      videoUrl: json['video']?['url'] ?? '',
      badge: json['badge'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      shareLink: json['shareLink'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isLive: json['isLive'] ?? false,

    );
  }
}
