// Removed unnecessary import 'dart:ffi';

class LiveSessionsResponse {
  final bool success;
  final List<Session> sessions;

  LiveSessionsResponse({
    required this.success,
    required this.sessions,
  });

  factory LiveSessionsResponse.fromJson(Map<String, dynamic> json) {
    return LiveSessionsResponse(
      success: json['success'] ?? false,
      sessions: (json['sessions'] as List<dynamic>?)
          ?.map((e) => Session.fromJson(e as Map<String, dynamic>)) // Added type cast
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'sessions': sessions.map((e) => e.toJson()).toList(),
    };
  }
}

class Session {
  final String id;
  final String title;
  final String? description;
  final String status;
   int viewersCount;
  final String? startTime; // for live/upcoming
  final String? scheduledStartTime; // for scheduled
  final String? channelName;
  final Host? host;

  Session({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.viewersCount,
    this.startTime,
    this.scheduledStartTime,
    this.channelName,
    this.host,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? '',
      viewersCount: json['viewersCount'] ?? 0,
      startTime: json['startTime'],
      scheduledStartTime: json['scheduledStartTime'],
      channelName: json['channelName'],
      host: json['hostId'] != null && json['hostId'] is Map<String, dynamic>
          ? Host.fromJson(json['hostId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'status': status,
      'viewersCount': viewersCount,
      'startTime': startTime,
      'scheduledStartTime': scheduledStartTime,
      'channelName': channelName,
      'hostId': host?.toJson(),
    };
  }
}

class Host {
  final String id;
  final String username;
  final String? profilePicUrl;
  final dynamic rating;

  Host({
    required this.id,
    required this.username,
    this.profilePicUrl,
    this.rating,
  });

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      profilePicUrl: json['profilePicUrl'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'profilePicUrl': profilePicUrl,
      'rating': rating,
    };
  }
}
