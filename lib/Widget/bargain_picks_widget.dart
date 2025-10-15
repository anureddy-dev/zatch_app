import 'package:flutter/material.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/view/ReelDetailsScreen.dart';
import 'package:zatch_app/view/reel/see_all_bargain_picks_screen.dart';
import '../controller/bargain_pick_controller.dart';

class BargainPicksWidget extends StatefulWidget {
  const BargainPicksWidget({super.key});

  @override
  State<BargainPicksWidget> createState() => _BargainPicksWidgetState();
}

class _BargainPicksWidgetState extends State<BargainPicksWidget> {
  // Your existing controller and state...
  final BargainPickController _controller = BargainPickController();
  final double cardImageWidth = 120.0;
  final double cardImageHeight = 175.0;

  @override
  Widget build(BuildContext context) {
    const double textSectionHeight = 65.0;
    final double totalCardHeight = cardImageHeight + textSectionHeight;

    if (_controller.picks.isEmpty) {
      // You can return an empty widget to not show this section at all
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Bargain picks - Zatching now"',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // --- 2. MODIFIED: Navigate to the new grid screen ---
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeeAllBargainPicksScreen(
                          picks: _controller.picks,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          /// Horizontal list of bargain picks
          SizedBox(
            height: totalCardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.picks.length > 3 ? 3 : _controller.picks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final pick = _controller.picks[index];

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == _controller.picks.length - 1 ? 0 : 12.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReelDetailsScreen(
                            bitId: /*pick.id*/ "68a2772c675bafdd4204ef0b", // Use the real ID from the data
                            controller: LiveStreamController(),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: BargainPickCard(
                      imageUrl: pick.thumbnail,
                      title: pick.title,
                      priceInfo: pick.subtitle.contains("Zatch from ")
                          ? pick.subtitle.split("Zatch from ")[1]
                          : pick.subtitle,
                      cardImageWidth: cardImageWidth,
                      cardImageHeight: cardImageHeight,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


/// Reusable card widget (Figma style) - No changes needed here
class BargainPickCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String priceInfo;
  final double cardImageWidth;
  final double cardImageHeight;

  const BargainPickCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.priceInfo,
    required this.cardImageWidth,
    required this.cardImageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return SizedBox(
      width: cardImageWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image with shadow
          Container(
            width: cardImageWidth,
            height: cardImageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              image: imageUrl.isEmpty
                  ? null
                  : DecorationImage(
                image: isNetworkImage
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider,
                fit: BoxFit.cover,
              ),
              color: imageUrl.isEmpty ? Colors.grey[200] : null,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: imageUrl.isEmpty
                ? Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 50,
              ),
            )
                : null,
          ),
          const SizedBox(height: 8),

          /// Title
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF787676),
              fontSize: 10,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          /// Static "Zatch from"
          const Text(
            'Zatch from',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Price info
          Text(
            priceInfo,
            style: const TextStyle(
              color: Color(0xFF94C800),
              fontSize: 12,
              fontFamily: 'Encode Sans',
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
