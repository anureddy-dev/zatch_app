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

  // List of states for the dropdown
  final List<String> states = [
    "Telangana",
    "AP",
    "Karnataka",
    "Tamil Nadu",
    "Kerala",
  ];

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
    // The Theme wrapper is no longer necessary since we removed persistentFooterButtons
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add New Address",
          style: TextStyle(
            color: Color(0xFF121111),
            fontSize: 16,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map and Locate Me Button Section
            Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  "https://picsum.photos/428/250", // Using a reliable placeholder
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Gracefully handle image load errors
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.map,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement locate me functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCCF656),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Locate Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Encode Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _CustomTextField(
                    controller: address1,
                    hintText: 'Enter Address',
                    labelText: 'Address line - 1',
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    controller: address2,
                    hintText: 'Enter Address',
                    labelText: 'Address line - 2',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _CustomTextField(
                          controller: pinCode,
                          hintText: 'Enter Pin Code',
                          labelText: 'Pin Code',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _CustomDropdown(
                          value: selectedState,
                          hint: 'Select State',
                          labelText: 'State',
                          items: states,
                          onChanged: (value) {
                            setState(() {
                              selectedState = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    controller: phone,
                    hintText: 'Enter Phone Number',
                    labelText: 'Phone',
                    keyboardType: TextInputType.phone,
                    prefixText: '+91',
                  ),
                  const SizedBox(height: 16),
                  // Optional Fields
                  _CustomTextField(
                    controller: latitude,
                    hintText: 'Enter Latitude',
                    labelText: 'Latitude (Optional)',
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    controller: longitude,
                    hintText: 'Enter Longitude',
                    labelText: 'Longitude (Optional)',
                  ),
                  const SizedBox(height: 32), // Added space before the button
                  // MOVED BUTTON HERE
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
                      backgroundColor: const Color(0xFFCCF656),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Select",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Encode Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for TextFields to match Figma design
class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String? prefixText;
  final TextInputType? keyboardType;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.prefixText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFFABABAB),
            fontSize: 14,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 16,
              fontFamily: 'Encode Sans',
            ),
            prefixIcon:
                prefixText != null
                    ? Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 8,
                        top: 15,
                        bottom: 15,
                      ),
                      child: Text(
                        prefixText!,
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    )
                    : null,
            filled: true,
            fillColor: const Color(0xFFF2F4F5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

// Custom widget for the Dropdown to match Figma design
class _CustomDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final String labelText;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _CustomDropdown({
    required this.value,
    required this.hint,
    required this.labelText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFFABABAB),
            fontSize: 14,
            fontFamily: 'Encode Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 16,
              fontFamily: 'Encode Sans',
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F4F5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
          items:
              items.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
        ),
      ],
    );
  }
}
