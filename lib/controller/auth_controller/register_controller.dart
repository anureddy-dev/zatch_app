import 'package:flutter/material.dart';
import 'package:zatch_app/model/register_req.dart';
import 'package:zatch_app/model/register_response_model.dart';
import 'package:zatch_app/services/api_service.dart';
import 'package:zatch_app/view/auth_view/OtpScreenRegister.dart';

class RegisterController {
  final api = ApiService();

  // Register user and send OTP
  Future<void> registerUser({
    required BuildContext context,
    required String username,
    required String password,
    required String countryCode,
    required String phone,
  }) async {
    try {
      final request = RegisterRequest(
        username: username,
        password: password,
        countryCode: countryCode,
        phone: phone,
      );

      // call API
      final RegisterResponse result = await api.registerUser(request);

      if (result.success) {
        debugPrint("Registration Success: ${result.message}");

        // navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreenRegister(
              phoneNumber: result.user.phone,
              countryCode: result.user.countryCode,
            ),
          ),
        );

      } else {
        debugPrint("Registration Failed: ${result.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      debugPrint(" Register Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }
}
