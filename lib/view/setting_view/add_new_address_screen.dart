import 'package:flutter/material.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController pinCode = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController latitude = TextEditingController();
  final TextEditingController longitude = TextEditingController();
  String? selectedState;

  @override
  void dispose() {
    address1.dispose();
    address2.dispose();
    pinCode.dispose();
    phone.dispose();
    latitude.dispose();
    longitude.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _textField("Address line - 1", controller: address1),
          const SizedBox(height: 12),
          _textField("Address line - 2", controller: address2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _textField("Pin Code", controller: pinCode)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Select State"),
                  items: ["Telangana", "AP", "Karnataka"]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Text("+91"),
              ),
              const SizedBox(width: 12),
              Expanded(child: _textField("Phone", controller: phone)),
            ],
          ),
          const SizedBox(height: 12),
          _textField("Latitude (optional)", controller: latitude),
          const SizedBox(height: 12),
          _textField("Longitude (optional)", controller: longitude),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                "address1": address1.text,
                "address2": address2.text,
                "pinCode": pinCode.text,
                "state": selectedState,
                "phone": phone.text,
                "lat": latitude.text,
                "lng": longitude.text,
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFFDAFF00),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Select", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _textField(String label, {required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(label),
    );
  }
}
