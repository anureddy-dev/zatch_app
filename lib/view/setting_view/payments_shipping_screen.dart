import 'package:flutter/material.dart';
import 'package:zatch_app/view/coupon_apply_screen.dart';
import 'package:zatch_app/view/order_place_screen.dart';
import 'package:zatch_app/view/setting_view/add_new_address_screen.dart';
import 'package:zatch_app/view/setting_view/payment_method_screen.dart';

class CheckoutOrPaymentsScreen extends StatefulWidget {
  final bool isCheckout; // true => Checkout, false => Payments & Shipping

  const CheckoutOrPaymentsScreen({super.key, this.isCheckout = true});

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
                /// 🛒 Show Cart Items only in Checkout
                if (widget.isCheckout) ...[
                  _cartItem("Modern light clothes", "Dress modern", 212.99, 3),
                  const SizedBox(height: 16),
                  _shippingInfo(),
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
                      builder:
                          (_) =>
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
                      MaterialPageRoute(
                        builder: (_) =>CouponApplyScreen()
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderPlacedScreen(),
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

  Widget _cartItem(String name, String desc, double price, int qty) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.network(
          "https://picsum.photos/60",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text("$qty"),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shippingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Shipping Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total (3 items)"),
            Text("1,014.95 ₹", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Shipping Fee"), Text("0.00 ₹")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Discount"), Text("0.00 ₹")],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sub Total", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "1,014.95 ₹",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
