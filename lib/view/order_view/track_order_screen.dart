
import 'package:flutter/material.dart';

enum OrderStatus { accepted, inTransit, outForDelivery, delivered, canceled }

class TrackOrderScreen extends StatelessWidget {
  final OrderStatus status;

  const TrackOrderScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildStepper(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const Divider(height: 32, thickness: 1),
            _buildProductCard(),
            const SizedBox(height: 20),
            _buildDeliveryLocation(),
            const SizedBox(height: 20),
            if (status == OrderStatus.inTransit || status == OrderStatus.delivered)
              _buildShippingDetails(),
            _buildShippingInfo(),
            const SizedBox(height: 20),
            _buildSellerProducts(),
          ],
        ),
      ),
    );
  }

  // 🔹 Stepper UI (order progress bar)
  Widget _buildStepper() {
    List<String> steps = [
      "Order Accepted",
      "In Transit",
      "Out for Delivery",
      status == OrderStatus.canceled ? "Order Canceled" : "Order Delivered"
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        bool isCompleted = index <= _currentStepIndex();
        bool isCanceled = status == OrderStatus.canceled && index == steps.length - 1;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: isCanceled
                        ? Colors.red
                        : (isCompleted ? Colors.green : Colors.grey[300]),
                    child: Icon(
                      isCanceled
                          ? Icons.close
                          : Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: (isCanceled && index == steps.length - 2)
                            ? Colors.red
                            : (isCompleted ? Colors.green : Colors.grey[300]),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isCanceled
                      ? Colors.red
                      : (isCompleted ? Colors.green : Colors.black),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  int _currentStepIndex() {
    switch (status) {
      case OrderStatus.accepted:
        return 0;
      case OrderStatus.inTransit:
        return 1;
      case OrderStatus.outForDelivery:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.canceled:
        return 1; // canceled after in transit
    }
  }

  // 🔹 Action Buttons
  Widget _buildActionButtons() {
    if (status == OrderStatus.delivered) {
      return Row(
        children: [
          Expanded(
            child: const Text("Help with Order"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Download Invoice"),
            ),
          ),
        ],
      );
    } else if (status == OrderStatus.canceled) {
      return ElevatedButton(
        onPressed: () {},
        child: const Text("Buy Again"),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text("Track Order"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text("Cancel Order"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Buy Again"),
            ),
          ),
        ],
      );
    }
  }

  // 🔹 Product Card
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
      trailing: const Text("442 ₹",
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // 🔹 Delivery Location
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

  // 🔹 Shipping Details (only for ongoing & delivered)
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

  // 🔹 Shipping Info
  Widget _buildShippingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Shipping Information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        _infoRow("Total (9 items)", "1,014.95 ₹"),
        _infoRow("Shipping Fee", "0.00 ₹"),
        _infoRow("Discount", "0.00 ₹"),
        const Divider(),
        _infoRow("Sub Total", "1,014.95 ₹"),
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

  // 🔹 Seller Products (horizontal list)
  Widget _buildSellerProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Products From This Seller",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _productCard("Max Ciro Men’s Slides", "\$148.00"),
              _productCard("Men’s Harrington Jacket", "\$148.00"),
              _productCard("Max Ciro Shirt", "\$148.00"),
            ],
          ),
        )
      ],
    );
  }

  Widget _productCard(String name, String price) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "https://i.pravatar.cc/200?img=8",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name,
                style:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(price,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
