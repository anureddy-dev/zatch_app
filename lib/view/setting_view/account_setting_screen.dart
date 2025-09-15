import 'package:flutter/material.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/help_screen.dart';
import 'package:zatch_app/view/order_view/order_screen.dart';
import 'package:zatch_app/view/setting_view/payments_shipping_screen.dart';
import 'package:zatch_app/view/setting_view/profile_screen.dart';
import 'account_details_screen.dart';
import 'package:zatch_app/view/policy_screen.dart';

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
    });

    try {
      final profileModel = await _apiService.getUserProfile();
      setState(() {
        userProfile = profileModel;
        isLoading = false;
      });
    } catch (e, st) {
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
      body:
          isLoading
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
                  Container(
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
                        _settingsTile(
                          Icons.account_circle,
                          "Account Details",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AccountDetailsScreen(
                                      userProfile: userProfile,
                                    ),
                              ),
                            );
                          },
                        ),
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
                                builder: (_) => CheckoutOrPaymentsScreen(isCheckout: false,),
                              ),
                            );
                          },
                        ),
                        _settingsTile(Icons.dark_mode, "Dark Mode", () {}),
                        _settingsTile(
                          Icons.tune,
                          "Change Preferences in shopping",
                          () {},
                        ),
                        _settingsTile(Icons.help_outline, "Help", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpScreen(),
                            ),
                          );
                        }),
                        _settingsTile(
                          Icons.info_outline,
                          "Understand Zatch",
                          () {},
                        ),
                        _settingsTile(Icons.privacy_tip, "Privacy Policy", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const PolicyScreen(
                                    title: "Privacy Policy",
                                  ),
                            ),
                          );
                        }),
                        _settingsTile(
                          Icons.description,
                          "Terms & Conditions",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const PolicyScreen(
                                      title: "Terms & Conditions",
                                    ),
                              ),
                            );
                          },
                        ),
                        _settingsTile(Icons.logout, "Log out", () {}),
                      ],
                    ),
                  ),
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
    final name = userProfile?.user.username ?? "Palwendar Kaur";
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
            backgroundImage: NetworkImage(profilePicUrl),
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
