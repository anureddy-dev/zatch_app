
import 'package:flutter/material.dart';
import 'package:zatch_app/view/cart_screen.dart';
import 'package:zatch_app/view/coupon_apply_screen.dart';
import 'package:zatch_app/view/order_place_screen.dart';
import 'package:zatch_app/view/setting_view/add_new_address_screen.dart';
import 'package:zatch_app/view/setting_view/payment_method_screen.dart';

class CheckoutOrPaymentsScreen extends StatefulWidget {
  final bool isCheckout;
  final List<CartItem>? selectedItems;
  final double? itemsTotalPrice;
  final double? shippingFee;
  final double? subTotalPrice;

  const CheckoutOrPaymentsScreen({
    super.key,
    this.isCheckout = true,
    this.selectedItems,
    this.itemsTotalPrice,
    this.shippingFee,
    this.subTotalPrice,
  });

  @override
  State<CheckoutOrPaymentsScreen> createState() =>
      _CheckoutOrPaymentsScreenState();
}

class _CheckoutOrPaymentsScreenState extends State<CheckoutOrPaymentsScreen> {
  int selectedAddress = 0;
  int selectedPayment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCheckout ? "Checkout" : "Payments and Shipping"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 🛒 Show Cart Items only in Checkout (NOW DYNAMIC)
                if (widget.isCheckout) ...[
                  // Use a ListView.builder for dynamic items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.selectedItems?.length ?? 0,
                    itemBuilder: (context, index) {
                      // --- FIX IS HERE ---
                      final item = widget.selectedItems?[index];
                      if (item == null) {
                        // Return an empty widget if item is null
                        return const SizedBox.shrink();
                      }
                      return _cartItem(item);
                    },
                  ),
                  const SizedBox(height: 16),
                  _shippingInfo(
                    itemCount: widget.selectedItems?.length ?? 0,
                    itemsTotal: widget.itemsTotalPrice ?? 0.0,
                    shipping: widget.shippingFee ?? 0.0,
                    subTotal: widget.subTotalPrice ?? 0.0,
                  ),
                  const SizedBox(height: 16),

                  /// 📧 Contact Details
                  const Text(
                    "Contact Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Email Address",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                /// 📍 Addresses
                const Text(
                  "Select Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _addressTile(
                  0,
                  "Home",
                  "A-403 Mantri Celestia, Financial District, Hyderabad",
                  Icons.home,
                ),
                _addressTile(
                  1,
                  "Office",
                  "A-403 Mantri Celestia, Financial District, Hyderabad",
                  Icons.apartment,
                ),
                _addressTile(
                  2,
                  "Other",
                  "Lorem ipsum street, Hyderabad",
                  Icons.location_on,
                ),
                const SizedBox(height: 8),
                _addNewButton("Add New Address", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddNewAddressScreen(),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                /// 💳 Payment
                const Text(
                  "Choose Payment Method",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _paymentTile(0, "VISA", "2143"),
                const SizedBox(height: 8),
                _addNewButton("Add New Payment", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentMethodScreen(data: PaymentData.getDummy()),
                    ),
                  );
                }),

                /// 🎟 Coupon only in Checkout
                if (widget.isCheckout) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Coupon Code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _couponCodeButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CouponApplyScreen()),
                    );
                    debugPrint("Coupon Apply tapped");
                  }),
                ],
              ],
            ),
          ),

          /// 🟩 Pay button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  OrderPlacedScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFFDAFF00),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Pay", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _couponCodeButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Apply Coupon Code",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF8B0000),
            ), // dark red arrow
          ],
        ),
      ),
    );
  }

  // Updated to take a CartItem object
  Widget _cartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "https://picsum.photos/seed/${item.name}/60", // Use item name as seed for unique image
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.description),
        trailing: Text(
          'Qty: ${item.quantity}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Updated to take dynamic data
  Widget _shippingInfo({
    required int itemCount,
    required double itemsTotal,
    required double shipping,
    required double subTotal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Shipping Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total ($itemCount items)"),
            Text(
              "${itemsTotal.toStringAsFixed(2)} ₹",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Shipping Fee"),
            Text("${shipping.toStringAsFixed(2)} ₹")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text("Discount"), Text("0.00 ₹")],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sub Total", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${subTotal.toStringAsFixed(2)} ₹",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addressTile(int index, String title, String subtitle, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: RadioListTile(
        value: index,
        groupValue: selectedAddress,
        onChanged: (val) => setState(() => selectedAddress = val!),
        activeColor: Colors.black,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        secondary: Icon(icon),
      ),
    );
  }

  Widget _paymentTile(int index, String type, String digits) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: RadioListTile(
        value: index,
        groupValue: selectedPayment,
        onChanged: (val) => setState(() => selectedPayment = val!),
        activeColor: Colors.black,
        title: Text("$type **** **** $digits"),
        secondary: const Icon(Icons.credit_card, color: Colors.blue),
      ),
    );
  }

  Widget _addNewButton(String text, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFDAFF00)),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color(0xFFDAFF00).withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
