import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zatch_app/model/user_model.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/model/ExploreApiRes.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';
import 'package:zatch_app/view/profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  final UserProfileResponse? userProfile;

  const SearchScreen({super.key, this.userProfile});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final FocusNode _searchFocusNode = FocusNode(); // 1. Declare FocusNode

  List<String> searchHistory = [];
  List<String> popularSearches = [];
  List<Bits> exploreBits = [];

  bool isLoading = false;

  List<UserModel> _allPeople = [];
  List<Product> _allProducts = [];

  List<UserModel> _searchResultsPeople = [];
  List<Product> _searchResultsProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSearchHistory();
    _fetchInitialData();

    // 2. Request focus after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  Future<void> _fetchInitialData() async {
    try {
      final api = ApiService();
      final searchHistoryResponse = await api.getUserSearchHistory();
      popularSearches =
          searchHistoryResponse.searchHistory.map((e) => e.query).toList();
      exploreBits = await api.getExploreBits();

      final peopleRes = await api.getAllUsers();
      _allPeople = peopleRes.users;

      final productsRes = await api.getProducts();
      _allProducts = productsRes;
    } catch (e, st) {
      debugPrint("Error fetching initial API data: $e\n$st");
    } finally {
      if (mounted) setState(() {});
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    _addSearch(query);

    setState(() {
      _searchResultsPeople = _allPeople
          .where((u) =>
          u.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();

      _searchResultsProducts = _allProducts
          .where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList("searchHistory") ?? [];
    });
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("searchHistory", searchHistory);
  }

  void _addSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      searchHistory.remove(query);
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
    });
    _saveSearchHistory();
  }

  void _clearSearch() {
    setState(() {
      searchHistory.clear();
    });
    _saveSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _searchFocusNode.dispose(); // 4. Dispose FocusNode
    super.dispose();
  }

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
                    TextSpan(
                      text: "Hello, Zatcher ",
                      style: TextStyle(fontSize: 12),
                    ),
                    WidgetSpan(
                      child: Text("👋", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                widget.userProfile?.user.username ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              focusNode: _searchFocusNode, // 3. Attach FocusNode
              controller: _searchController,
              onSubmitted: (value) {
                if (value.isNotEmpty) _performSearch(value);
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchResultsPeople.clear();
                    _searchResultsProducts.clear();
                  });
                } else {
                  _performSearch(value);
                }
              },
              decoration: InputDecoration(
                hintText: "Search Products or People. . .",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResultsPeople.clear();
                      _searchResultsProducts.clear();
                    });
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isSearching
          ? _buildSearchResults()
          : _buildInitialBody(),
    );
  }

  // ... (Rest of the SearchScreen file remains unchanged)

  /// ---------------- Initial Body ----------------
  Widget _buildInitialBody() => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchHistory.isNotEmpty) _buildLastSearch(),
        if (popularSearches.isNotEmpty) _buildPopularSearch(),
        if (exploreBits.isNotEmpty) _buildExploreGrid(),
        const SizedBox(height: 20),
        _buildSection(
          "Products",
          _allProducts.take(4).toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductListScreen(products: _allProducts),
              ),
            );
          },
        ),
        _buildSection(
          "People",
          _allPeople.take(6).toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PeopleListScreen(people: _allPeople),
              ),
            );
          },
        ),
      ],
    ),
  );

  Widget _buildLastSearch() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Last Search",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextButton(
            onPressed: _clearSearch,
            child: const Text(
              "Clear All",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      Wrap(
        spacing: 8,
        children: searchHistory.map((search) {
          return InputChip(
            label: Text(search),
            onPressed: () {
              _searchController.text = search;
              _performSearch(search);
              FocusScope.of(context).unfocus();
            },
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () {
              setState(() {
                searchHistory.remove(search);
              });
              _saveSearchHistory();
            },
            labelStyle: const TextStyle(color: Colors.black87),
          );
        }).toList(),
      ),
    ],
  );

  Widget _buildPopularSearch() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Popular Search",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 12),
      ...popularSearches.map((search) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage("https://placehold.co/95x118"),
          ),
          title: Text(search),
          subtitle: const Text("Trending product"),
          trailing: const Text("212.99 ₹"),
          onTap: () {
            _searchController.text = search;
            _performSearch(search);
          },
        );
      }).toList(),
    ],
  );

  Widget _buildExploreGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Explore",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: exploreBits.length,
          itemBuilder: (context, index) {
            final bit = exploreBits[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                bit.videoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection(String title, List items,
      {required VoidCallback onSeeAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: onSeeAll, child: const Text("See All")),
          ],
        ),
        if (title == "Products")
          _searchProductsTab(items.cast<Product>(), simple: true),
        if (title == "People")
          _searchPeopleTab(items.cast<UserModel>(), simple: true),
      ],
    );
  }

  /// ---------------- Search Results ----------------
  Widget _buildSearchResults() {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding:
          const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade600,
          indicator: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          controller: _tabController,
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
              _searchPeopleTab(_searchResultsPeople),
              _searchProductsTab(_searchResultsProducts),
            ],
          ),
        ),
      ],
    );
  }

  Widget _searchAllTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Products",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        _searchProductsTab(_searchResultsProducts, simple: true),
        const SizedBox(height: 20),
        const Text("People",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        _searchPeopleTab(_searchResultsPeople, simple: true),
      ],
    );
  }

  Widget _searchProductsTab(List<Product> products, {bool simple = false}) {
    if (products.isEmpty) {
      return const Center(child: Text("No products found"));
    }
    return ListView.builder(
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];


        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.images[index].url,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          title: Text(product.name),
          subtitle: const Text("Product"),
          trailing: Text("${product.price} ₹"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productId: product.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _searchPeopleTab(List<UserModel> people, {bool simple = false}) {
    if (people.isEmpty) {
      return const Center(child: Text("No people found"));
    }
    return ListView.builder(
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
      itemCount: people.length,
      itemBuilder: (context, index) {
        final user = people[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: (user.profilePic.url?.isNotEmpty ?? false)
                ? NetworkImage(user.profilePic.url!)
                : null,
            child: (user.profilePic.url == null ||
                user.profilePic.url!.isEmpty)
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.displayName),
          subtitle: Text("${user.followerCount} Followers"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: user.id),
              ),
            );
          },
        );
      },
    );
  }
}

/// ---------------- See All Screens ----------------
class ProductListScreen extends StatelessWidget {
  final List<Product> products;
  const ProductListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) => ListTile(title: Text(products[i].name)),
      ),
    );
  }
}

class PeopleListScreen extends StatelessWidget {
  final List<UserModel> people;
  const PeopleListScreen({super.key, required this.people});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All People")),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (_, i) => ListTile(title: Text(people[i].displayName)),
      ),
    );
  }
}
