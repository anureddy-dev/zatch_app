class RegisterRequest {
  final String username;
  final String password;
  final String countryCode;
  final String phone;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.countryCode,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "countryCode": countryCode,
      "phone": phone,
    };
  }
}
