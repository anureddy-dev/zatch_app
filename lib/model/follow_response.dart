class FollowResponse {
  final bool success;
  final String message;
  final int followerCount;

  FollowResponse({
    required this.success,
    required this.message,
    required this.followerCount,
  });

  factory FollowResponse.fromJson(Map<String, dynamic> json) {
    return FollowResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      followerCount: json["followerCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "followerCount": followerCount,
    };
  }
}
