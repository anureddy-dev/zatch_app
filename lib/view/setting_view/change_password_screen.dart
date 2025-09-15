import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const ChangePasswordScreen({
    super.key,
    this.name = "Raju Nikil",
    this.email = "d.v.a.v.raju@gmail.com",
    this.avatarUrl = "https://i.pravatar.cc/150?img=12",
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscCur = true;
  bool _obscNew = true;
  bool _obscCon = true;

  static const brandGreen = Color(0xFFA3DD00);

  String? _validateNew(String? v) {
    final s = v?.trim() ?? "";
    if (s.isEmpty) return "Enter a new password";
    if (s.length < 8) return "At least 8 characters";
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(s);
    final hasDigit = RegExp(r'\d').hasMatch(s);
    if (!hasLetter || !hasDigit) return "Use letters & numbers";
    if (_currentCtrl.text.trim() == s) {
      return "New password must differ from current";
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return "Re-enter the password";
    if (v.trim() != _newCtrl.text.trim()) return "Passwords don’t match";
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: connect to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // light background like screenshot
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Change Password",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Main Card (Profile + Inputs)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(widget.avatarUrl),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(widget.email,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFEAEAEA)),

                    const SizedBox(height: 16),

                    // Current password
                    TextFormField(
                      controller: _currentCtrl,
                      obscureText: _obscCur,
                      decoration: _inputDecoration(
                        label: "Current Password",
                        toggle: () => setState(() => _obscCur = !_obscCur),
                        obscured: _obscCur,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? "Enter your current password"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // New password
                    TextFormField(
                      controller: _newCtrl,
                      obscureText: _obscNew,
                      decoration: _inputDecoration(
                        label: "Enter Password",
                        toggle: () => setState(() => _obscNew = !_obscNew),
                        obscured: _obscNew,
                      ),
                      validator: _validateNew,
                    ),
                    const SizedBox(height: 12),

                    // Confirm password
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscCon,
                      decoration: _inputDecoration(
                        label: "Re-Enter Password",
                        toggle: () => setState(() => _obscCon = !_obscCon),
                        obscured: _obscCon,
                      ),
                      validator: _validateConfirm,
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: brandGreen, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Save Changes"),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required VoidCallback toggle,
    required bool obscured,
  }) {
    return InputDecoration(
      hintText: label, // matches screenshot (placeholder style)
      filled: true,
      fillColor: const Color(0xFFF6F6F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      suffixIcon: IconButton(
        icon: Icon(obscured ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
