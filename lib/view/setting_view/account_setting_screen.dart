import 'package:flutter/material.dart';
import 'package:zatch_app/model/carts_model.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/services/preference_service.dart';
import 'package:zatch_app/view/category_screen/category_screen.dart';
import 'package:zatch_app/view/help_screen.dart';
import 'package:zatch_app/view/order_view/order_screen.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';
import 'package:zatch_app/view/setting_view/profile_screen.dart';
import 'package:zatch_app/view/zatching_details_screen.dart';
import 'account_details_screen.dart';
import 'package:zatch_app/view/policy_screen.dart';
import 'dart:convert'; // ✅ for jsonEncode()

class AccountSettingsScreen extends StatefulWidget {
  final VoidCallback? onOpenAccountDetails;

  const AccountSettingsScreen({super.key, this.onOpenAccountDetails});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final ApiService _apiService = ApiService();
  UserProfileResponse? userProfile;
  bool isLoading = true;
  String? error;
  String? rawResponseText; // ✅ to display raw API data

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserProfile();
    });
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
      error = null;
      rawResponseText = null;
    });

    try {
      final profileModel = await _apiService.getUserProfile();

      // ✅ Capture the response as a readable JSON string
      final jsonResponse = const JsonEncoder.withIndent('  ')
          .convert(profileModel.toJson());

      setState(() {
        userProfile = profileModel;
        rawResponseText = jsonResponse; // store it for screen display
        isLoading = false;
      });

      print("✅ Profile Response (JSON): $jsonResponse");
    } catch (e, st) {
      print("❌ Error fetching user profile: $e");
      print(st);
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: _appBar("Account Settings"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Error: $error"))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(userProfile),
                ),
              );
            },
            child: _profileCard(userProfile),
          ),

          const SizedBox(height: 16),
/*

          // ✅ DEBUG RESPONSE SECTION
          if (rawResponseText != null) ...[
            const Text(
              "🔍 API Response:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  rawResponseText!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
*/

          // ✅ SETTINGS CARD SECTION
          _settingsContainer(),
        ],
      ),
    );
  }

  // Reusable settings container
  Widget _settingsContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // In the _settingsContainer method:

          _settingsTile(Icons.account_circle, "Account Details", () async {
            // ✅ ADD THIS PRINT STATEMENT
            print("--- Tapped 'Account Details'. Navigating to screen. No API call is made yet. ---");

            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => AccountDetailsScreen(
                  userProfile: userProfile,
                ),
              ),
            );
            if (result == true) {
              print("✅ Navigated back from AccountDetailsScreen with success. Refreshing profile...");
              fetchUserProfile(); // API call happens HERE
            } else {
              // ✅ ADD THIS FOR CLARITY
              print("--- Navigated back from AccountDetailsScreen without success signal. No refresh needed. ---");
            }
          }),
          _settingsTile(Icons.shopping_cart, "Zatches", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ZatchingDetailsScreen(
                  zatch: Zatch(
                    id: "3",
                    name: "Modern light clothes",
                    description: "Dress modern",
                    seller: "Neu Fashions, Hyderabad",
                    imageUrl: "https://picsum.photos/202/300",
                    active: false,
                    status: "Offer Rejected",
                    quotePrice: "212.99 ₹",
                    sellerPrice: "800 ₹",
                    quantity: 4,
                    subTotal: "800 ₹",
                    date: "Yesterday 12:00PM",
                  ),
                ),
              ),
            );
          }),
          _settingsTile(Icons.shopping_cart, "Your Orders", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrdersScreen()),
            );
          }),
          _settingsTile(
            Icons.local_shipping,
            "Payments and Shipping",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CheckoutOrPaymentsScreen(isCheckout: false),
                ),
              );
            },
          ),
          _settingsTile(Icons.dark_mode, "Dark Mode", () {}),
          _settingsTile(Icons.tune, "Change Preferences in shopping", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(    builder: (_) => CategoryScreen(
                title: "Your Preferences",
              ),
              ),
            );

          }),
          _settingsTile(Icons.help_outline, "Help", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HelpScreen(),
              ),
            );
          }),
          _settingsTile(Icons.info_outline, "Understand Zatch", () {}),
          _settingsTile(Icons.privacy_tip, "Privacy Policy", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PolicyScreen(title: "Privacy Policy"),
              ),
            );
          }),
          _settingsTile(Icons.description, "Terms & Conditions", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const PolicyScreen(title: "Terms & Conditions"),
              ),
            );
          }),
          _settingsTile(Icons.logout, "Log out", () async {
            setState(() => isLoading = true);
            final prefs = PreferenceService();

            try {
              await _apiService.logoutUser();
              await prefs.logoutAll();

              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout failed: $e")),
                );
              }
            } finally {
              if (mounted) setState(() => isLoading = false);
            }
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(String title) {
    return AppBar(
      backgroundColor: const Color(0xFFF2F2F2),
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _profileCard(UserProfileResponse? userProfile) {
    final name = userProfile?.user.username ?? "Unknown User";
    final followers = userProfile?.user.followerCount?.toString() ?? "0";
    final profilePicUrl =
    (userProfile?.user.profilePic.url.isNotEmpty ?? false)
        ? userProfile!.user.profilePic.url
        : "";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
            profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
            child: profilePicUrl.isEmpty ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "$followers Followers",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
