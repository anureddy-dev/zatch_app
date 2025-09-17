import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zatch_app/controller/auth_controller/login_controller.dart';
import 'package:zatch_app/model/categories_response.dart';
import 'package:zatch_app/view/category_screen/category_screen.dart';
import 'package:zatch_app/view/home_page.dart';
import '../../utils/auth_utils/base_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedCountryCode = "+91";

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

  /*Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final res = await _loginController.loginUser(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(loginResponse: res,),
        ),
      );

      *//*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(loginResponse: res),
        ),
      );*//*
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }*/

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final res = await _loginController.loginUser(
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final selectedCategories = prefs.getStringList("userCategories") ?? [];

      if (selectedCategories.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(loginResponse: res),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              loginResponse: res,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  Future<void> _handleOtpLogin() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      final phone = _loginController.getRegisteredPhone() ?? "9019058876";
      final countryCode = _loginController.getRegisteredCountryCode() ?? "+91";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: /*phone*/ "9019058876",
            countryCode: countryCode,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          title: 'Login here',
          subtitle: 'Welcome back you’ve been missed!',
          contentWidgets: [
            SizedBox(height: spacingLarge),

            /// Phone + Country code
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
                      _selectedCountryCode = countryCode.dialCode ?? "+91";
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

            /// Password
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

            /// Login button
            GestureDetector(
              onTap: _handleLogin,
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
            GestureDetector(onTap: (){
              Navigator.pushNamed(context, '/register');
            },
              child: Padding(
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
            ),

            SizedBox(height: spacingSmall),

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

            /// Sign in with OTP
            GestureDetector(
              onTap: _handleOtpLogin,
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

            SizedBox(height: spacingLarge),
          ],

          bottomText: Text.rich(
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
        ),

        /// ✅ Full screen loader overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
