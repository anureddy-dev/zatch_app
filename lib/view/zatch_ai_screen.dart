import 'package:flutter/material.dart';

class ZatchAiScreen extends StatefulWidget {
  const ZatchAiScreen({super.key});

  @override
  State<ZatchAiScreen> createState() => _ZatchAiScreenState();
}

class _ZatchAiScreenState extends State<ZatchAiScreen> {
  final TextEditingController _chatController = TextEditingController();

  // Fake suggestion list
  final List<Map<String, String>> suggestions = [
    {
      "title": "Men's Harrington Jacket",
      "price": "\$148.00",
      "sold": "1,200 sold this week",
      "discount": "56% OFF",
      "image": "https://via.placeholder.com/150"
    },
    {
      "title": "Max Cirro Men’s Slides",
      "price": "\$148.00",
      "sold": "1,200 sold this week",
      "discount": "55% OFF",
      "image": "https://via.placeholder.com/150"
    },
  ];

  final List<String> promptLibrary = [
    "Best Sneakers",
    "Low Cost Sneakers",
    "Mens Jackets",
    "Slides",
    "Tech Products"
  ];

  final List<String> chatHistory = [];

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      chatHistory.add(_chatController.text.trim());
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Zatch Ai",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        children: [
          // Suggestions section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text("Suggestions",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all"),
                )
              ],
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(item["image"]!, fit: BoxFit.cover),
                          )),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(item["title"]!,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(item["price"]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(item["sold"]!,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12)),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
            ),
          ),

          // Prompt Library
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 8,
              children: promptLibrary
                  .map((p) => Chip(
                label: Text(p),
                backgroundColor: Colors.grey.shade200,
              ))
                  .toList(),
            ),
          ),

          const Divider(),

          // Chat history
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(chatHistory[index]),
                  ),
                );
              },
            ),
          ),

          // Chat input
          SafeArea(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: "Ask anything",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.green),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
