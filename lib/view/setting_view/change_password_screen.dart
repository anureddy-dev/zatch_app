import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/auth_view/login.dart';
import 'package:zatch_app/view/setting_view/account_setting_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final UserProfileResponse? userProfile;

  const ChangePasswordScreen({
    super.key,
    this.userProfile,
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
  bool _isLoading = false;

  static const brandGreen = Color(0xFFA3DD00);

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Prefill current password if available (optional)
    _currentCtrl.text = widget.userProfile?.user.password ?? "";
  }

  String? _validateNew(String? v) {
    final s = v?.trim() ?? "";
    if (s.isEmpty) return "Enter a new password";
    if (s.length < 8) return "At least 8 characters";
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(s);
    final hasDigit = RegExp(r'\d').hasMatch(s);
    if (!hasLetter || !hasDigit) return "Use letters & numbers";
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return "Re-enter the password";
    if (v.trim() != _newCtrl.text.trim()) return "Passwords don’t match";
    return null;
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.changePassword(
        newPassword: _newCtrl.text.trim(),
        confirmPassword: _confirmCtrl.text.trim(),
      );

      if (response['success'] == true) {
        // ✅ Show success Flushbar
        Flushbar(
          title: "Success",
          message: response['message'] ?? 'Password changed successfully!',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(
            Icons.check_circle_outline,
            size: 28.0,
            color: Colors.white,
          ),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);

        _newCtrl.clear();
        _confirmCtrl.clear();
        _currentCtrl.clear();

          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false, // removes all previous routes
            );
          }
      } else {
        // ❌ Show error Flushbar
        Flushbar(
          title: "Error",
          message: response['message'] ?? 'Failed to change password',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.white,
          ),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
    } catch (e) {
      // ❌ Show error Flushbar for exceptions
      Flushbar(
        title: "Error",
        message: e.toString(),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.white,
        ),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
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
      backgroundColor: const Color(0xFFF2F2F2),
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
              // Main Card
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
                          backgroundImage: NetworkImage(
                            widget.userProfile?.user.profilePic.url ?? "",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userProfile?.user.username ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(widget.userProfile?.user.email ?? "",
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
                        label: "Enter New Password",
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
                        label: "Re-Enter New Password",
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
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ✅ Save Changes button with API call
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleChangePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
      hintText: label,
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
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
