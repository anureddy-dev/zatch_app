import 'package:flutter/material.dart';
import 'package:zatch_app/view/profile/profile_screen.dart';

import '../product_view/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> lastSearches = [
    "Electronics",
    "Pants",
    "Lorimipsum",
    "Three Second",
    "Long Shirt",
    "Lorimi"
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _clearAll() {
    setState(() {
      lastSearches.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Sample data
  final List<Map<String, String>> popularProducts = [
    {
      "title": "Modern light clothes",
      "subtitle": "Dress modern",
      "price": "212.99 ₹",
      "image": "https://i.imgur.com/BoN9kdC.png" // Placeholder image
    },
    {
      "title": "Modern light clothes",
      "subtitle": "Dress modern",
      "price": "212.99 ₹",
      "image": "https://i.imgur.com/BoN9kdC.png"
    }
  ];

  final List<Map<String, String>> people = [
    {
      "name": "Ankitha Lauren",
      "followers": "215.1K Followers",
      "image": "https://randomuser.me/api/portraits/women/65.jpg"
    },
    {
      "name": "Ankitha Lauren",
      "followers": "215.1K Followers",
      "image": "https://randomuser.me/api/portraits/men/65.jpg"
    },
    {
      "name": "Ankitha Lauren",
      "followers": "215.1K Followers",
      "image": "https://randomuser.me/api/portraits/men/43.jpg"
    },
    {
      "name": "Ankitha Lauren",
      "followers": "215.1K Followers",
      "image": "https://randomuser.me/api/portraits/women/12.jpg"
    }
  ];

  final List<String> exploreImages = [
    "https://images.pexels.com/photos/753626/pexels-photo-753626.jpeg",
    "https://images.pexels.com/photos/36753/blue-building-architecture-details.jpg",
    "https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg",
    "https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg",
    "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg",
    "https://images.pexels.com/photos/3225517/pexels-photo-3225517.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffd5ff4d),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Hello, Welcome ", style: TextStyle(fontSize: 12)),
                    WidgetSpan(
                      child: Text("👋", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                "Raju Nikil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
          Stack(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black)),
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    "3",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search Products or People. . .",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: isSearching
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _searchController.text.isEmpty ? _buildInitialBody() : _buildSearchResults(),
    );
  }

  Widget _buildInitialBody() => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLastSearch(),
        const SizedBox(height: 12),
        _buildPopularSearch(),
        const SizedBox(height: 12),
        _buildExploreGrid(),
        const SizedBox(height: 12),
      ],
    ),
  );

  Widget _buildLastSearch() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Last Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextButton(
            onPressed: _clearAll,
            child: const Text("Clear All", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: lastSearches.map((e) => Chip(
          label: Text(e),
          onDeleted: () {
            setState(() {
              lastSearches.remove(e);
            });
          },
          deleteIconColor: Colors.grey,
          backgroundColor: Colors.grey.shade200,
          labelStyle: const TextStyle(color: Colors.black87),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        )).toList(),
      )
    ],
  );

  Widget _buildPopularSearch() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Popular Search", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      ...popularProducts.map((product) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(product['subtitle']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(product['price']!)
              ],
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.lightGreenAccent.shade400, borderRadius: BorderRadius.circular(8)),
              child: const Text("Trending", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      )),
    ],
  );

  Widget _buildExploreGrid() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Explore", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 12),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: exploreImages.map((img) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(img, fit: BoxFit.cover),
        )).toList(),
      )
    ],
  );

  Widget _buildSearchResults() {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          indicator: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          tabs: const [
            Tab(text: "All"),
            Tab(text: "People"),
            Tab(text: "Products"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _searchAllTab(),
              _searchPeopleTab(),
              _searchProductsTab(),
            ],
          ),
        )
      ],
    );
  }

  ListView _searchAllTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700)),
        const SizedBox(height: 10),
        _searchProductsTab(simple: true),
        const SizedBox(height: 20),
        Text("People", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700)),
        const SizedBox(height: 10),
        _searchPeopleTab(simple: true),
      ],
    );
  }

  ListView _searchProductsTab({bool simple = false}) {
    return ListView.builder(
      padding: simple ? EdgeInsets.zero : const EdgeInsets.all(16),
      itemCount: popularProducts.length,
      itemBuilder: (context, index) {
        final product = popularProducts[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(product['image']!, width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(product['title']!),
          subtitle: Text(product['subtitle']!),
          trailing: Text(product['price']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen( productId: '',),
              ),
            );
          },
        );
      },
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
    );
  }

  ListView _searchPeopleTab({bool simple = false}) {
    return ListView.builder(
      padding: simple ? EdgeInsets.zero : const EdgeInsets.all(16),
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(person['image']!),
          ),
          title: Text(person['name']!),
          subtitle: Text(person['followers']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(person: person),
              ),
            );
          },
        );
      },
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
    );
  }
}
