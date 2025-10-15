import 'package:flutter/material.dart';
import 'package:zatch_app/Widget/top_picks_this_week_widget.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/model/product_response.dart';

enum OrderStatus { accepted, inTransit, outForDelivery, delivered, canceled }

class TrackOrderScreen extends StatefulWidget {
  final OrderStatus status;

  const TrackOrderScreen({super.key, required this.status});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    try {
      return await _apiService.getProducts();
    } catch (e) {
      debugPrint("Error fetching products: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Track Order"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomStepper(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const Divider(height: 32, thickness: 1),
            _buildProductCard(),
            const SizedBox(height: 20),
            _buildDeliveryLocation(),
            const SizedBox(height: 20),
            if (widget.status == OrderStatus.inTransit ||
                widget.status == OrderStatus.delivered)
              _buildShippingDetails(),
            _buildShippingInfo(),
            const SizedBox(height: 20),
            TopPicksThisWeekWidget(title: "Products form this seller",showSeeAll: false,)
          ],
        ),
      ),
    );
  }

  // ----------------------------
  // ✅ Custom Stepper
  // ----------------------------
  Widget _buildCustomStepper() {
    List<String> steps = [
      "Order\nAccepted",
      "In\nTransit",
      "Out for\nDelivery",
      widget.status == OrderStatus.canceled
          ? "Order\nCanceled"
          : "Order\nDelivered"
    ];

    int currentIndex = _currentStepIndex();

    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: 40,
            right: 40,
            top: 20,
            child: Stack(
              children: [
                Container(height: 2, color: Colors.grey[300]),
                FractionallySizedBox(
                  widthFactor: currentIndex / (steps.length - 1),
                  alignment: Alignment.centerLeft,
                  child: Container(height: 2, color: Colors.green),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(steps.length, (index) {
              bool isCompleted = index <= currentIndex;
              bool isCanceled = widget.status == OrderStatus.canceled &&
                  index == steps.length - 1;

              Color circleColor = isCanceled
                  ? Colors.red
                  : (isCompleted
                  ? const Color(0xFFA2DC00)
                  : const Color(0xFFDDDDDD));

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleColor,
                        ),
                      ),
                      if (isCanceled)
                        const Icon(Icons.close, color: Colors.white, size: 18)
                      else if (isCompleted)
                        const Icon(Icons.check, color: Colors.white, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isCanceled
                          ? Colors.red
                          : (isCompleted
                          ? Colors.green
                          : const Color(0xFF2C2C2C)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  int _currentStepIndex() {
    switch (widget.status) {
      case OrderStatus.accepted:
        return 0;
      case OrderStatus.inTransit:
        return 1;
      case OrderStatus.outForDelivery:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.canceled:
        return 1;
    }
  }

  // ----------------------------
  // ✅ Action Buttons
  // ----------------------------
  Widget _buildActionButtons() {
    Widget _customButton(
        String label, {
          Color bgColor = const Color(0xFFF1F1F1),
          Color textColor = const Color(0xFF272727),
          VoidCallback? onPressed,
        }) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 44,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.white.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    if (widget.status == OrderStatus.delivered) {
      return Row(
        children: [
          Expanded(child: _customButton("Help with Order")),
          const SizedBox(width: 8),
          Expanded(child: _customButton("Download Invoice")),
        ],
      );
    } else if (widget.status == OrderStatus.canceled) {
      return Center(
        child: SizedBox(
          width: 160,
          child: _customButton(
            "Buy Again",
            bgColor: Colors.green,
            textColor: Colors.white,
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(child: _customButton("Track Order")),
          const SizedBox(width: 8),
          Expanded(child: _customButton("Cancel Order")),
          const SizedBox(width: 8),
          Expanded(
              child: _customButton(
                "Buy Again",
                bgColor: Colors.green,
                textColor: Colors.white,
              )),
        ],
      );
    }
  }

  // ----------------------------
  // ✅ Product Card
  // ----------------------------
  Widget _buildProductCard() {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          "https://i.pravatar.cc/100?img=5",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: const Text("Modern light clothes",
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text("Dress modern"),
      trailing:
      const Text("₹442", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // ----------------------------
  // ✅ Delivery Location
  // ----------------------------
  Widget _buildDeliveryLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Delivery Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: const [
              Icon(Icons.home, color: Colors.black54),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "A-403 Mantri Celestia, Financial District, Nanakram Guda...",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------
  // ✅ Shipping Details
  // ----------------------------
  Widget _buildShippingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Shipping Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text("Deliver on: 12 Aug 2025",
            style: TextStyle(fontSize: 14, color: Colors.black87)),
        SizedBox(height: 12),
      ],
    );
  }

  // ----------------------------
  // ✅ Shipping Info
  // ----------------------------
  Widget _buildShippingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shipping Information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        _infoRow("Total (9 items)", "₹1,014.95"),
        _infoRow("Shipping Fee", "₹0.00"),
        _infoRow("Discount", "₹0.00"),
        const Divider(),
        _infoRow("Sub Total", "₹1,014.95"),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          Text(value,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // ----------------------------
  // ✅ Seller Products (API integrated)
  // ----------------------------
  Widget _buildSellerProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products From This Seller",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Product>>(
            future: _futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              final products = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _productCard(product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _productCard(Product product) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.images.first.url.isNotEmpty == true
                    ? product.images!.first.url
                    : "https://via.placeholder.com/150",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name ?? "Unknown",
              style:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              "₹${product.price ?? 0}",
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
