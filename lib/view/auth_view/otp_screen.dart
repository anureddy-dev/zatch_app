import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zatch_app/controller/auth_controller/otp_controller.dart';
import 'package:zatch_app/model/verify_otp_response.dart';
import '../../utils/auth_utils/base_screen.dart';
import 'package:zatch_app/utils/local_storage.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());

  final OtpController _otpController = OtpController();

  bool _isLoading = false;
  int _resendTimer = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _sendOtpOnStart();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  /// Auto-send OTP on screen load
  Future<void> _sendOtpOnStart() async {
    setState(() => _isLoading = true);
    final res =
    await _otpController.sendOtp(widget.phoneNumber, widget.countryCode);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(res != null
              ? "OTP sent to ${res.to}"
              : "❌ Failed to send OTP")),
    );

    _startResendTimer();
  }

  /// Resend OTP
  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _canResend = false;
    });

    final res =
    await _otpController.sendOtp(widget.phoneNumber, widget.countryCode);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(res != null
              ? "OTP resent to ${res.to}"
              : "❌ Failed to resend OTP")),
    );

    _startResendTimer();
  }

  /// Verify OTP
  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter complete 4-digit OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final VerifyOtpResponse? res =
    await _otpController.verifyOtp(widget.phoneNumber, widget.countryCode, otp);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res != null && res.valid == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ OTP Verified Successfully")),
      );
      final hasCategorySelected = await LocalStorage.hasSelectedCategory();
      if (hasCategorySelected) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/categories');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ OTP Failed. Status: ${res?.status}")),
      );
    }
  }

  /// Timer
  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (_resendTimer > 1) {
        setState(() => _resendTimer--);
        return true;
      } else {
        setState(() {
          _resendTimer = 0;
          _canResend = true;
        });
        return false;
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BaseScreen(
          title: 'Login here',
          subtitle: 'Welcome back you’ve been missed!',
          contentWidgets: [
            const SizedBox(height: 20),
            const Text(
              "OTP Verification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the 4-digit OTP sent to ${widget.countryCode}${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            /// OTP input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _focusNodes[index].hasFocus
                          ? const Color(0xFFCCF656)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onChanged: (value) => _onOtpChanged(value, index),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            /// Resend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive OTP ? "),
                GestureDetector(
                  onTap: _canResend ? _resendOtp : null,
                  child: Text(
                    _canResend ? "Resend" : "Resend in $_resendTimer sec",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: _canResend
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
          bottomText: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(color: Colors.green),
                  ),
                  child: const Text("Back",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCF656),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Login",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),

        /// ✅ Full-screen loader
        if (_isLoading)
          Container(
            color: Colors.black45,
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
