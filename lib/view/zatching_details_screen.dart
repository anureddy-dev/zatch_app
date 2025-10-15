import 'package:flutter/material.dart';
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/view/cart_screen.dart';

class ZatchingDetailsScreen extends StatelessWidget {
  final Zatch zatch;

  const ZatchingDetailsScreen({super.key, required this.zatch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Center(child: const Text("Zatching", style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _offerCard(context),
                const SizedBox(height: 16),

                if (zatch.status == "Zatch Expired") _expiredSection(context),
                if (zatch.status == "Offer Rejected") _offerRejectedSection(context),
                if (zatch.status == "Seller Offer") _sellerOfferSection(context),
              ],
            ),
          ),
          _bottomInfo(),
        ],
      ),
    );
  }

  /// 🟩 My Offer Card
  Widget _offerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Offer",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(zatch.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  zatch.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zatch.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(zatch.description ?? "—",
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(zatch.quotePrice,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text("${zatch.quantity}PCS",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sub Total",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(zatch.subTotal,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  /// ⏳ Expired Section
  Widget _expiredSection(BuildContext context) {
    return Column(
      children: [
        _statusBubble(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: const Icon(Icons.flash_on, size: 16, color: Colors.white),
          ),
          title: "Zatch Expired",
        ),
        const SizedBox(height: 12),
        _priceCard("Original Price", showAddToCart: true,context:   context),
      ],
    );
  }

  /// ❌ Offer Rejected
  Widget _offerRejectedSection(BuildContext context) {
    return Column(
      children: [
        _statusBubble(
          icon: const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/men/32.jpg", // example seller
            ),
          ),
          title: "Offer Rejected",
        ),
        const SizedBox(height: 12),
        _priceCard("Original Price", showAddToCart: true,context: context),
      ],
    );
  }

  /// 🟡 Seller Offer
  Widget _sellerOfferSection(BuildContext context) {
    return Column(
      children: [
        _statusBubble(
          icon: const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/men/45.jpg", // example seller
            ),
          ),
          title: "Seller Offer",
        ),
        const SizedBox(height: 12),
        _priceCard("Seller Offer", showAddToCart: true, showPay: true,context: context),
      ],
    );
  }

  /// 💬 Status Bubble (icon + white bubble with title + time)
  Widget _statusBubble({required Widget icon, required String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(zatch.date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 📦 Price Card
  Widget _priceCard(String title,
      {bool showAddToCart = false, bool showPay = false, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Text(zatch.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  zatch.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zatch.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(zatch.description ?? "—",
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(zatch.sellerPrice.isNotEmpty
                            ? zatch.sellerPrice
                            : zatch.quotePrice),
                        Text("${zatch.quantity}PCS",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sub Total",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(zatch.subTotal,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),

          /// Buttons inside card (like your screenshot)
          if (showAddToCart)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.shade100,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(),
                    ),
                  );
                },
                child: const Text("Add To Cart"),
              ),
            ),
          if (showPay)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.shade100,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text("Pay"),
              ),
            ),
        ],
      ),
    );
  }

  /// ℹ️ Bottom Info
  Widget _bottomInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          Icon(Icons.info, size: 18, color: Colors.green),
          SizedBox(width: 6),
          Text("Zatches will expire in 2 business days",
              style: TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
