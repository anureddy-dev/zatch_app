import 'package:flutter/material.dart';
import 'package:zatch_app/controller/auth_controller/register_controller.dart';
import '../../utils/auth_utils/base_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegisterController _controller = RegisterController();
  String _countryCode = "91";
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final double inputHeight = screenHeight * 0.06;
    final double inputFontSize = screenWidth * 0.035;
    final double buttonFontSize = screenWidth * 0.045;
    final double spacingSmall = screenHeight * 0.02;
    final double spacingLarge = screenHeight * 0.04;
    final double paddingVertical = screenHeight * 0.018;

    return Stack(
      children: [
        BaseScreen(
          title: 'Register',
          subtitle: 'Welcome to Zatch!!',
          // Wrap entire content + bottom text in scroll
          contentWidgets: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: spacingLarge),

                  /// Username Field
                  Container(
                    height: inputHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: inputFontSize,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: spacingSmall),

                  /// Phone + Country Code
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
                              _countryCode =
                                  countryCode.dialCode!.replaceAll("+", "");
                            });
                          },
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: inputFontSize,
                          ),
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
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: inputFontSize,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacingSmall),

                  /// Password Field
                  Container(
                    height: inputHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: inputFontSize,
                        ),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacingLarge),

                  /// Register Button
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
                      setState(() => _isLoading = true);
                      await _controller.registerUser(
                        context: context,
                        username: nameController.text.trim(),
                        password: _passwordController.text.trim(),
                        countryCode: _countryCode,
                        phone: _phoneController.text.trim(),
                      );
                      if (mounted) setState(() => _isLoading = false);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: paddingVertical),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFCCF656),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Verify Phone',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: spacingLarge),


                  SizedBox(height: 40),
                ],
              ),
            ),
            /// Terms & Conditions
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'By continuing you are accepting all\n ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: inputFontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: inputFontSize,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),


        /// Loading Overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

      ],
    );
  }
}
