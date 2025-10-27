import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zatch_app/model/user_profile_response.dart';
import 'package:zatch_app/services/api_service.dart';
import 'change_info_screen.dart';
import 'change_password_screen.dart';

class AccountDetailsScreen extends StatefulWidget {
  final UserProfileResponse? userProfile;
  final VoidCallback? onBack;

  const AccountDetailsScreen({super.key, this.userProfile, this.onBack});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controllers are late-initialized but safely within initState.
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  String gender = "";
  String _selectedCountryCode = "+91";

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  late List<String> _days;
  final List<String> _months = const [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  late List<String> _years;

  bool _isLoading = false;
  bool _isFormValid = false;

  // ✅ FIX: The profile state can be nullable.
  UserProfileResponse? _currentProfile;

  @override
  void initState() {
    super.initState();

    // ✅ FIX: Safely check for null before using the profile.
    if (widget.userProfile == null) {
      // If no profile is passed, we can't initialize the form.
      // The build method will handle showing an error message.
      _currentProfile = null;
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _emailController = TextEditingController();
    } else {
      // If the profile exists, proceed with initialization.
      _currentProfile = widget.userProfile!;
      final user = _currentProfile!.user;

      _nameController = TextEditingController(text: user.username);
      _phoneController = TextEditingController(text: user.phone);
      _emailController = TextEditingController(text: user.email);
      gender = user.gender;
      _selectedCountryCode = user.countryCode ?? "+91";

      // ✅ FIX: Safer DOB parsing.
      if (user.dob != null && user.dob!.isNotEmpty) {
        final parts = user.dob!.split("-");
        if (parts.length == 3) {
          _selectedYear = parts[0];
          final monthIndex = int.tryParse(parts[1]);
          if (monthIndex != null && monthIndex >= 1 && monthIndex <= 12) {
            _selectedMonth = _months[monthIndex - 1];
          }
          _selectedDay = parts[2].padLeft(2, '0');
        }
      }

      // Add listeners only if the form is being populated.
      _nameController.addListener(_validateForm);
      _phoneController.addListener(_validateForm);
      _emailController.addListener(_validateForm);
    }

    // Initialize DOB dropdown lists.
    _days = List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
    int currentYear = DateTime.now().year;
    _years = List.generate(100, (i) => (currentYear - i).toString());

    // Run initial validation.
    _validateForm();
  }

  void _validateForm() {
    // Also check if the profile exists before trying to validate.
    if (_currentProfile == null) {
      if (mounted) setState(() => _isFormValid = false);
      return;
    }

    if (mounted) {
      setState(() {
        _isFormValid = _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _selectedDay != null &&
            _selectedMonth != null &&
            _selectedYear != null &&
            gender.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inputHeight = size.height * 0.06;
    final inputFontSize = size.width * 0.035;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _appBar("Account Details"),
      body: SafeArea(
        child: _currentProfile == null
            ? const Center(
          child: Text(
            "User profile not available.",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        )
            : Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileHeader(),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Colors.grey),
                      const SizedBox(height: 24),
                      _buildTextField("Name", _nameController),
                      const SizedBox(height: 16),
                      _buildLabel("Gender"),
                      const SizedBox(height: 8),
                      _genderSelector(),
                      const SizedBox(height: 16),
                      _buildLabel("Date of Birth"),
                      const SizedBox(height: 8),
                      _dateOfBirthFields(),
                      const SizedBox(height: 16),
                      _phoneField(inputHeight, inputFontSize),
                      const SizedBox(height: 16),
                      _buildTextField("Email", _emailController),
                      const SizedBox(height: 16),
                      _passwordField(),
                      const SizedBox(height: 30),
                      _actionButtons(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black38,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  // -------------------- UI Helpers --------------------
  PreferredSizeWidget _appBar(String title) => AppBar(
    backgroundColor: Colors.grey.shade100,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        if (widget.onBack != null) {
          widget.onBack!();
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    ),
    centerTitle: true,
    title: Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
  );

  Widget _profileHeader() {
    // This is now safe because we check for a null profile in the build method.
    final profilePicUrl = _currentProfile!.user.profilePic.url;
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
              child: profilePicUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFA3DD00),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.edit, color: Colors.black, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_nameController.text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text(_emailController.text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14));

  Widget _buildTextField(String label, TextEditingController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );

  Widget _passwordField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildLabel("Password"),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: "********",
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          suffix: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen()),
              );
            },
            child: const Text("Change Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFA3DD00))),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );

  Widget _genderSelector() {
    final options = {"Male": Icons.male, "Female": Icons.female, "Other": Icons.transgender};
    return Row(
      children: options.entries.map((entry) {
        final isSelected = gender == entry.key;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              gender = entry.key;
              _validateForm();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFA3DD00) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(entry.value, color: isSelected ? Colors.black : Colors.grey),
                  const SizedBox(width: 6),
                  Text(entry.key,
                      style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dateOfBirthFields() {
    return Row(
      children: [
        _dobDropdown(_days, _selectedDay, "DD", (v) => setState(() {
          _selectedDay = v;
          _validateForm();
        })),
        const SizedBox(width: 8),
        _dobDropdown(_months, _selectedMonth, "MM", (v) => setState(() {
          _selectedMonth = v;
          _validateForm();
        })),
        const SizedBox(width: 8),
        _dobDropdown(_years, _selectedYear, "YYYY", (v) => setState(() {
          _selectedYear = v;
          _validateForm();
        })),
      ],
    );
  }

  Widget _dobDropdown(List<String> items, String? value, String hint,
      void Function(String?) onChanged) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _phoneField(double inputHeight, double inputFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Phone"),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  setState(() {
                    _selectedCountryCode = countryCode.dialCode ?? "+91";
                    _validateForm();
                  });
                },
                initialSelection: 'IN',
                favorite: const ['+91', 'IN'],
                textStyle: TextStyle(color: Colors.black, fontSize: inputFontSize),
                showFlag: false,
                showDropDownButton: true,
                padding: EdgeInsets.zero,
                dialogTextStyle: TextStyle(fontSize: inputFontSize),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter phone number',
                  ),
                  style: TextStyle(fontSize: inputFontSize),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.maybePop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Color(0xFFA3DD00))),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Cancel", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid ? _handleSaveChanges : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA3DD00),
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // -------------------- Save Logic --------------------
  void _handleSaveChanges() async {
    // This logic is now safe because we've confirmed _currentProfile is not null.
    final oldPhone = _currentProfile!.user.phone;
    final oldEmail = _currentProfile!.user.email;
    final oldDob = _currentProfile!.user.dob;

    final newPhone = _phoneController.text.trim();
    final newEmail = _emailController.text.trim();
    final newDob =
        "${_selectedYear!}-${(_months.indexOf(_selectedMonth!) + 1).toString().padLeft(2, '0')}-${_selectedDay!}";

    final phoneChanged = newPhone != oldPhone;
    final emailChanged = newEmail != oldEmail;
    final dobChanged = newDob != oldDob;

    final otherChanges =
        _nameController.text.trim() != _currentProfile!.user.username ||
            gender != _currentProfile!.user.gender ||
            dobChanged;

    if (!phoneChanged && !emailChanged && !otherChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes were made.")),
      );
      return;
    }

    if (emailChanged) {
      setState(() => _isLoading = true);
      try {
        await _apiService.sendEmailOtp(newEmail);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeInfoScreen(
              title: "Email Verification",
              subtitle: "Enter the OTP received on your email",
              showEmail: true,
              showPhone: false,
              onVerified: ({emailOtp, phoneOtp}) {
                _updateProfileLoader(
                  otp: emailOtp,
                  otpType: "email",
                  dob: newDob,
                );
              },
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending Email OTP: $e")),
        );
      } finally {
        if(mounted) setState(() => _isLoading = false);
      }
      return;
    }
    if (phoneChanged) {
      setState(() => _isLoading = true);
      try {
        await _apiService.sendPhoneOtp(_selectedCountryCode, newPhone);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeInfoScreen(
              title: "Mobile Verification",
              subtitle: "Enter the OTP received on your mobile number",
              showEmail: false,
              showPhone: true,
              onVerified: ({emailOtp, phoneOtp}) {
                _updateProfileLoader(
                  otp: phoneOtp,
                  otpType: "phone",
                  dob: newDob,
                );
              },
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error sending Phone OTP: $e")),
        );
      } finally {
        if(mounted) setState(() => _isLoading = false);
      }
      return;
    }

    if (otherChanges) {
      _updateProfileLoader(dob: newDob);
    }
  }

  Future<void> _updateProfileLoader({
    String? otp,
    String? phoneOtp,
    String? otpType,
    String? dob,
  }) async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.updateUserProfile(
        name: _nameController.text.trim(),
        gender: gender,
        dob: dob,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        countryCode: _selectedCountryCode,
        otp: otp,
        otpType: otpType,
      );

      print("Update Profile Request Sent.");
      print("Update Profile Response: $response");

      if (!mounted) return;

      setState(() {
        // Here you would ideally update _currentProfile with the response data
        // For now, we just stop loading.
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      // Optionally pop the screen or refresh previous screen state
      Navigator.pop(context, true); // Pop back and indicate success

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
