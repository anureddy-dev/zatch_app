import 'package:flutter/material.dart';
import 'package:zatch_app/model/TrendingBit.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/ReelDetailsScreen.dart';
import 'package:zatch_app/view/live_view/see_all_live_screen.dart';

class AllTrendingScreen extends StatefulWidget {
  const AllTrendingScreen({super.key});

  @override
  State<AllTrendingScreen> createState() => _AllTrendingScreenState();
}

class _AllTrendingScreenState extends State<AllTrendingScreen> {
  late Future<List<TrendingBit>> trendingFuture;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    trendingFuture = _api.fetchTrendingBits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Trending"),
      ),
      body: FutureBuilder<List<TrendingBit>>(
        future: trendingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No trending items"));
          }

          final bits = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 320,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: bits.length,
            itemBuilder: (context, index) {
              final bit = bits[index];
              return GestureDetector(
                onTap: () {
                  if (bit.isLive == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SeeAllLiveScreen(liveSessions: []),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReelDetailsScreen(bitId: bit.id ?? ''),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          bit.videoUrl ?? bit.videoUrl ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.error)),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bit.title ?? 'Untitled',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bit.description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
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
            },
          );
        },
      ),
    );
  }
}
