import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  const CommonTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
class CancelRegistrationModal extends StatelessWidget {
  const CancelRegistrationModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Dialog(
      backgroundColor: Colors.transparent, // Make the default dialog background transparent
      elevation: 0,
      child: _buildModalContent(context),
    );
  }
Widget _buildModalContent(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A101828),
            blurRadius: 8,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x19101828),
            blurRadius: 24,
            offset: Offset(0, 20),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important for the dialog to fit its content
        children: [
          // Header Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 42, 16, 24), // Combined padding
            child: Text(
              'Are you sure you want to cancel\nRegistration Process',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F1728),
                fontSize: 18,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.56,
              ),
            ),
          ),

          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Column(
              children: [
                // "Don't Save" Button (Refactored from "Cancel")
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 59),
                    side: const BorderSide(width: 1, color: Colors.black),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                     int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                  child: const Text(
                    "Don't Save", // Renamed for clarity
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // "Save To Draft" Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 59),
                    side: const BorderSide(width: 1, color: Colors.black),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // Implement save to draft logic here
                    print("Saving to draft...");
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Save To Draft',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // "Continue" Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA2DC00),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0, // Remove default elevation if shadows are in the parent
                  ),
                  onPressed: () {
                    // Close the modal and continue with the registration
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Encode Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
