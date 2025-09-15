import 'package:flutter/material.dart';

class ChangeInfoScreen extends StatefulWidget {
  final String title;
  final String subtitle; // 🔥 added subtitle
  final bool showEmail;
  final bool showPhone;
  final VoidCallback onVerified;

  const ChangeInfoScreen({
    super.key,
    required this.title,
    this.subtitle = "",
    this.showEmail = false,
    this.showPhone = false,
    required this.onVerified
  });

  @override
  State<ChangeInfoScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<ChangeInfoScreen> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  final _emailOtpControllers = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var c in _emailOtpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFA3DD00), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFA3DD00), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Widget _otpRow(List<TextEditingController> controllers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: controllers
          .map((c) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: _buildOtpField(c),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFFA3DD00);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (widget.subtitle.isNotEmpty)
              Text(
                widget.subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.showPhone) ...[
                    const Text(
                      "Mobile Verification",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter the 4-digit OTP received on your mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    _otpRow(_otpControllers),
                    const SizedBox(height: 12),
                    const Text.rich(
                      TextSpan(
                        text: "Didn't receive OTP ? ",
                        children: [
                          TextSpan(
                            text: "Resend in 30 sec",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (widget.showEmail) ...[
                    const Text(
                      "Email Verification",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter the 4-digit OTP received on your Email",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    _otpRow(_emailOtpControllers),
                    const SizedBox(height: 12),
                    const Text.rich(
                      TextSpan(
                        text: "Didn't receive OTP ? ",
                        children: [
                          TextSpan(
                            text: "Resend in 30 sec",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                  ],
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("OTP Verified Successfully")),
                        );
                        widget.onVerified();
                        Navigator.pop(context);
                      },
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
    );
  }
}
