import 'package:flutter/material.dart';
import '../../utils/auth_utils/base_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'otp_screen.dart'; // Ensure this import matches your project structure

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

    return BaseScreen(
      title: 'Login here',
      subtitle: 'Welcome back you’ve been missed!',
      contentWidgets: [
        SizedBox(height: spacingLarge),
        // Phone number input row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Adjusted size of +91 box to prevent overflow
              SizedBox(
                height: inputHeight,
                width: screenWidth * 0.3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryCodePicker(
                        onChanged: (countryCode) {
                          print('Selected code: ${countryCode.dialCode}');
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
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Increased size of mobile number field
              Expanded(
                flex: 2,
                child: Container(
                  height: inputHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
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
        ),
        SizedBox(height: spacingSmall),
        // Password Field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Container(
            height: inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F5),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: inputFontSize,
                ),
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: spacingLarge),
        // Login button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                'Login',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: buttonFontSize,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: spacingSmall),
        // Divider with "Or"
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(child: Divider(thickness: 1, color: Colors.black26)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Or',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: inputFontSize,
                  ),
                ),
              ),
              const Expanded(child: Divider(thickness: 1, color: Colors.black26)),
            ],
          ),
        ),
        SizedBox(height: spacingSmall),
        // Sign in with OTP button with navigation and feedback
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OtpScreen(phoneNumber: '+91 9019058876',)),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: const BorderSide(color: Colors.green),
                ),
              ),
              child: Center(
                child: Text(
                  'Sign in with OTP',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: inputFontSize + 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: spacingLarge),
        // "Don't have account?" text
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Don’t have an account? ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.w400,
                    height: 1.64,
                  ),
                ),
                TextSpan(
                  text: 'Create Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: inputFontSize,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    height: 1.64,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],

    );
  }
}