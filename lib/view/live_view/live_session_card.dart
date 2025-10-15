import 'package:flutter/material.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/live_session_res.dart';
import 'package:zatch_app/view/LiveDetailsScreen.dart';

class LiveSessionCard extends StatelessWidget {
  final Session liveSession;
  final double? width;
  final double? height;

  const LiveSessionCard({
    super.key,
    required this.liveSession,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final sessionBackgroundUrl = liveSession.host?.profilePicUrl ??
        'https://placehold.co/600x400/cccccc/999999?text=${Uri.encodeComponent(liveSession.title ?? "Live")}';

    final hostAvatarUrl = liveSession.host?.profilePicUrl ??
        'https://placehold.co/40x40/777777/ffffff?text=${(liveSession.host?.username.isNotEmpty ?? false) ? liveSession.host!.username[0].toUpperCase() : "U"}';

    final hostName = liveSession.host?.username ?? 'Host';
    final sessionTopic = liveSession.title ?? "General";

    return GestureDetector(
      onTap: () {
        final liveController = LiveStreamController(session: liveSession);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LiveStreamScreen(controller: liveController, username: hostName),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.network(
                sessionBackgroundUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[500]),
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
              // Live Badge
              if ((liveSession.status).toLowerCase() == 'live')
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBBF711),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(
                      'Live  ${liveSession.viewersCount ?? 0}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Host Info
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        hostAvatarUrl,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) => Container(
                          width: 28,
                          height: 28,
                          color: Colors.grey[400],
                          child: const Icon(Icons.person, size: 16, color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hostName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sessionTopic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
