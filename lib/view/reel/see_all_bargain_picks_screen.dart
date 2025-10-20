import 'package:flutter/material.dart';
// Make sure the import path below points correctly to where BargainPickCard is defined
import 'package:zatch_app/Widget/bargain_picks_widget.dart';
import 'package:zatch_app/model/bargain_pick_model.dart';
import 'package:zatch_app/view/ReelDetailsScreen.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';

class SeeAllBargainPicksScreen extends StatelessWidget {
  final List<BargainPick> picks;

  const SeeAllBargainPicksScreen({
    super.key,
    required this.picks,
  });

  @override
  Widget build(BuildContext context) {
    const double cardImageWidth = 160.0;
    const double cardImageHeight = 220.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bargain Picks For You',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          crossAxisSpacing: 8.0, // Horizontal space between cards
          mainAxisSpacing: 8.0,  // Vertical space between cards
          childAspectRatio: 0.60, // Taller rectangular cards
        ),
        itemCount: picks.length,
        itemBuilder: (context, index) {
          final pick = picks[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReelDetailsScreen(
                    bitId: /*pick.id*/"68a2772c675bafdd4204ef0b",
                    controller: LiveStreamController(),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: BargainPickCard(
              imageUrl: pick.thumbnail,
              title: pick.title,
              priceInfo: pick.subtitle.contains("Zatch from ")
                  ? pick.subtitle.split("Zatch from ")[1]
                  : pick.subtitle,
              cardImageWidth: cardImageWidth,
              cardImageHeight: cardImageHeight,
            ),
          );
        },
      ),
    );
  }
}
