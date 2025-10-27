import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:zatch_app/controller/live_stream_controller.dart';
import 'package:zatch_app/model/user_model.dart';
import 'package:zatch_app/model/product_response.dart';
import 'package:zatch_app/model/ExploreApiRes.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/ReelDetailsScreen.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/product_view/product_detail_screen.dart';
import 'package:zatch_app/view/profile/profile_screen.dart';

// Main Search Screen Widget
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
  final FocusNode _searchFocusNode = FocusNode();

  List<String> searchHistory = [];
  List<String> popularSearches = [];
  List<Bits> exploreBits = [];

  bool isLoading = true; // Start with loading true

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

    // Auto-focus the search bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  Future<void> _fetchInitialData() async {
    setState(() => isLoading = true);
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
      // Handle error, maybe show a snackbar
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResultsPeople.clear();
        _searchResultsProducts.clear();
      });
      return;
    }
    _addSearch(query);
    setState(() {
      _searchResultsPeople =
          _allPeople
              .where(
                (u) =>
                    u.displayName.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();

      _searchResultsProducts =
          _allProducts
              .where(
                (p) =>
                    p.name.toLowerCase().contains(query.toLowerCase()) ||
                    p.description.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        searchHistory = prefs.getStringList("searchHistory") ?? [];
      });
    }
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("searchHistory", searchHistory);
  }

  void _addSearch(String query) {
    if (query.isEmpty || searchHistory.contains(query)) return;
    setState(() {
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
    });
    _saveSearchHistory();
  }

  void _clearSearch() {
    setState(() => searchHistory.clear());
    _saveSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearching = _searchController.text.isNotEmpty;

    // FIX 1: Handle System Back Button correctly when searching
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          _searchController.clear();
          FocusScope.of(context).unfocus(); // Hide keyboard
          return false; // Prevent app from closing
        }
        return true; // Allow app to close or pop screen
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Color(0xffd5ff4d)),
                )
                : isSearching
                ? _buildSearchResults()
                : _buildInitialBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
                  WidgetSpan(child: Text("👋", style: TextStyle(fontSize: 12))),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userId: widget.userProfile?.user.id,),
              ),
            );          },
          icon: const Icon(Icons.bookmark_border, color: Colors.black),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/notification'),
          icon: const Icon(Icons.notifications_none, color: Colors.black),
        ),
        IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              ),
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: TextField(
            focusNode: _searchFocusNode,
            controller: _searchController,
            onSubmitted: _performSearch,
            onChanged: _performSearch, // Perform search as user types
            decoration: InputDecoration(
              hintText: "Search Products or People...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                      : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
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
    );
  }

  // --- UI Sections ---
  Widget _buildInitialBody() => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
          onSeeAll:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(products: _allProducts),
                ),
              ),
        ),
        const SizedBox(height: 20),
        _buildSection(
          "People",
          _allPeople.take(6).toList(),
          onSeeAll:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PeopleListScreen(people: _allPeople),
                ),
              ),
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
        children:
            searchHistory
                .map(
                  (search) => InputChip(
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _searchController.text.length),
                      );
                      _performSearch(search);
                    },
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() => searchHistory.remove(search));
                      _saveSearchHistory();
                    },
                  ),
                )
                .toList(),
      ),
      const SizedBox(height: 20),
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
      ...popularSearches.map(
        (search) => ListTile(
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
        ),
      ),
      const SizedBox(height: 20),
    ],
  );

  Widget _buildExploreGrid() => Column(
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
          // FIX 3: Make explore videos playable
          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ReelDetailsScreen(
                          bitId: bit.id,
                          controller: LiveStreamController(),
                        ),
                  ),
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://placehold.co/300x500/000000/FFFFFF?text=Video", // Use a placeholder thumbnail
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.ondemand_video),
                        ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 20),
    ],
  );

  Widget _buildSection(
    String title,
    List items, {
    required VoidCallback onSeeAll,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: onSeeAll, child: const Text("See All")),
        ],
      ),
      const SizedBox(height: 8),
      if (title == "Products" && items.isNotEmpty)
        _searchProductsTab(items.cast<Product>(), simple: true),
      if (title == "People" && items.isNotEmpty)
        _searchPeopleTab(items.cast<UserModel>(), simple: true),
    ],
  );

  // --- Search Results UI ---
  Widget _buildSearchResults() {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
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

  Widget _searchAllTab() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text(
        "Products",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 8),
      _searchProductsTab(_searchResultsProducts, simple: true),
      const SizedBox(height: 20),
      const Text(
        "People",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 8),
      _searchPeopleTab(_searchResultsPeople, simple: true),
    ],
  );

  Widget _searchProductsTab(List<Product> products, {bool simple = false}) {
    if (products.isEmpty)
      return const Center(heightFactor: 5, child: Text("No products found"));
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.images.isNotEmpty
                  ? product.images.first.url
                  : "https://placehold.co/100",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          title: Text(product.name),
          subtitle: Text(product.category?.name ?? "Product"),
          trailing: Text("${product.price} ₹"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProductDetailScreen(productId: product.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _searchPeopleTab(List<UserModel> people, {bool simple = false}) {
    if (people.isEmpty)
      return const Center(heightFactor: 5, child: Text("No people found"));
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: simple,
      physics: simple ? const NeverScrollableScrollPhysics() : null,
      itemCount: people.length,
      itemBuilder: (context, index) {
        final user = people[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                (user.profilePic?.url?.isNotEmpty ?? false)
                    ? NetworkImage(user.profilePic!.url!)
                    : null,
            child:
                (user.profilePic?.url == null || user.profilePic!.url!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
          ),
          title: Text(user.displayName),
          subtitle: Text("${user.followerCount} Followers"),
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: user.id),
                ),
              ),
        );
      },
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final List<Product> products;
  const ProductListScreen({super.key, required this.products});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Controller to manage the search text field
  late final TextEditingController _searchController;
  // List to hold the products that match the search query
  late List<Product> _filteredProducts;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initially, the filtered list is the complete list of products
    _filteredProducts = widget.products;

    // Add a listener to the controller to filter the list whenever the text changes
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  // --- START: Filtering Logic ---
  void _filterProducts() {
    final query = _searchController.text;
    if (query.isEmpty) {
      // If the search query is empty, show all products
      setState(() {
        _filteredProducts = widget.products;
      });
    } else {
      // Otherwise, filter the products based on the name
      setState(() {
        _filteredProducts = widget.products.where((product) {
          // Case-insensitive search
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }
  // --- END: Filtering Logic ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'All Products',
          style: TextStyle(
            color: Color(0xFF121111),
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Reduced vertical padding
              decoration: ShapeDecoration(
                color: const Color(0xFFEFF3EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // --- START: Updated TextField ---
              child: TextField(
                controller: _searchController, // Use the controller
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: Color(0xFF626262), size: 20),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Color(0xFF626262),
                    fontSize: 14,
                    fontFamily: 'Encode Sans',
                    fontWeight: FontWeight.w300,
                  ),
                  border: InputBorder.none, // Hide the default underline
                ),
                style: const TextStyle( // Style for the user's input text
                  color: Color(0xFF272727),
                  fontSize: 14,
                  fontFamily: 'Encode Sans',
                ),
              ),
              // --- END: Updated TextField ---
            ),
          ),
          Expanded(
            // --- Use the _filteredProducts list for the GridView ---
            child: _filteredProducts.isEmpty
                ? const Center(child: Text("No products found."))
                : LayoutBuilder(
              builder: (context, constraints) {
                const double childAspectRatio = 0.7;
                // --- The GridView now uses _filteredProducts ---
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(35, 10, 35, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: _filteredProducts.length, // Use the length of the filtered list
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index]; // Get product from the filtered list
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(productId: product.id),
                        ),
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                      child: Image.network(
                                        product.images.isNotEmpty
                                            ? product.images.first.url
                                            : "https://placehold.co/168x139",
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Center(
                                          child: Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          // TODO: Implement favorite functionality
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Color(0xFF272727),
                                      fontSize: 12,
                                      fontFamily: 'Encode Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '₹ ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF272727),
                                      fontSize: 12,
                                      fontFamily: 'Encode Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
      appBar: AppBar(
        title: const Text("All People"),
        backgroundColor: const Color(0xffd5ff4d),
        foregroundColor: Colors.black,
      ),
      body:
          people.isEmpty
              ? const Center(child: Text("No users to display."))
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final user = people[index];
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userId: user.id),
                          ),
                        ),
                    child: Column(
                      children: [
                        Expanded(
                          child: CircleAvatar(
                            radius: double.infinity,
                            backgroundImage:
                                (user.profilePic?.url?.isNotEmpty ?? false)
                                    ? NetworkImage(user.profilePic!.url!)
                                    : null,
                            child:
                                (user.profilePic?.url?.isEmpty ?? true)
                                    ? const Icon(Icons.person, size: 40)
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.displayName,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Use a placeholder if the URL is invalid or local
    final Uri uri = Uri.parse(widget.videoUrl);
    _controller =
        uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https')
            ? VideoPlayerController.networkUrl(uri)
            : VideoPlayerController.asset(
              "assets/videos/placeholder.mp4",
            ); // Add a placeholder video to your assets

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              );
            } else {
              return const CircularProgressIndicator(color: Colors.white);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            }),
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
