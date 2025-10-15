// lib/view/live_view/live_session_card.dart
import 'package:flutter/material.dart';
import 'package:zatch_app/model/live_session_res.dart';

class LiveSessionCard extends StatelessWidget {
  final Session liveSession;
  final VoidCallback onTap;
  final double cardWidth;
  final double cardHeight;

  const LiveSessionCard({
    super.key,
    required this.liveSession,
    required this.onTap,
    this.cardWidth = 131.0, // Default width from your original code
    this.cardHeight = 158.0, // Default height from your original code
  });

  @override
  Widget build(BuildContext context) {
     String sessionBackgroundUrl = liveSession.id ??
        liveSession.host?.profilePicUrl ?? // Fallback to host pic if no cover image
        'https://placehold.co/${cardWidth.toInt()}x${cardHeight.toInt()}/E0E0E0/B0B0B0?text=${Uri.encodeComponent(liveSession.title ?? 'No Title')}';

    // Image for the small circular host avatar
    String hostAvatarUrl = liveSession.host?.profilePicUrl ??
        'https://placehold.co/20x20/777777/FFFFFF?text=${(liveSession.host?.username?.isNotEmpty ?? false) ? liveSession.host!.username![0].toUpperCase() : "U"}';

    String hostName = liveSession.host?.username ?? 'Unknown Host';
    String sessionTopic = liveSession.title ?? "Live Session"; // Or use a category field if available
    bool isLive = liveSession.status?.toLowerCase() == 'live';
    String viewersCount = liveSession.viewersCount?.toString() ?? "0";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration( // Added this to handle potential margin/padding if needed by design
          // color: Colors.transparent, // Or a background color if cards are not fully covered by image
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0), // Consistent with your original code
          child: Stack(
            fit: StackFit.expand, // Ensures children can fill the card
            children: [
              // 1. Background Image
              Positioned.fill(
                child: Image.network(
                  sessionBackgroundUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: Center(
                        child: Icon(Icons.broken_image_outlined,
                            color: Colors.grey[500], size: cardHeight / 3)),
                  ),
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA3DD00)),
                        strokeWidth: 2.0,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),

              // 2. Gradient Overlay
              Positioned.fill(
                child: Opacity(
                  opacity: 0.70, // From your original code
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.50, -0.00),
                        end: const Alignment(0.50, 1.00),
                        colors: [
                          Colors.black.withOpacity(0.30),
                          Colors.black.withOpacity(0.21),
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.32),
                          Colors.black.withOpacity(0.60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content Layer
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(10.0), // General padding for content
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end, // Align content to bottom
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Host Info Row (Avatar and Name/Topic)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 6.0), // Spacing between avatar and text
                            child: ClipOval(
                              child: Image.network(
                                hostAvatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                    color: Colors.grey[400],
                                    child: Icon(Icons.person, size: 12, color: Colors.white70)),
                              ),
                            ),
                          ),
                          Expanded( // Allow text to take available space and truncate
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min, // Important for Column inside Row
                              children: [
                                Text(
                                  hostName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Plus Jakarta Sans', // Ensure this font is in pubspec
                                      fontWeight: FontWeight.w700,
                                      shadows: [Shadow(blurRadius: 2, color: Colors.black54, offset: Offset(0,1))]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (sessionTopic.isNotEmpty) // Only show if topic is available
                                  Text(
                                    sessionTopic,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 7,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w700, // Figma often uses bold for small text too
                                        shadows: [Shadow(blurRadius: 1, color: Colors.black38)]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              // 6. Live Badge (Top Left - outside the main content padding)
              if (isLive)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFBBF711), // Figma color from your code
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: 'Encode Sans', // Ensure this font is in pubspec
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          viewersCount,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: 'Encode Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
