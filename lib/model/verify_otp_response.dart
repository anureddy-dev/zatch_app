class VerifyOtpResponse {
  final String? sid;
  final String? serviceSid;
  final String? accountSid;
  final String? to;
  final String? channel;
  final String? status;
  final bool? valid;
  final String? amount;
  final String? payee;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  VerifyOtpResponse({
    this.sid,
    this.serviceSid,
    this.accountSid,
    this.to,
    this.channel,
    this.status,
    this.valid,
    this.amount,
    this.payee,
    this.dateCreated,
    this.dateUpdated,
  });

  /// ✅ Factory constructor to parse JSON
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      sid: json['sid'],
      serviceSid: json['serviceSid'],
      accountSid: json['accountSid'],
      to: json['to'],
      channel: json['channel'],
      status: json['status'],
      valid: json['valid'],
      amount: json['amount'],
      payee: json['payee'],
      dateCreated: json['dateCreated'] != null
          ? DateTime.tryParse(json['dateCreated'])
          : null,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.tryParse(json['dateUpdated'])
          : null,
    );
  }

  /// ✅ Convert model back to JSON
  Map<String, dynamic> toJson() {
    return {
      "sid": sid,
      "serviceSid": serviceSid,
      "accountSid": accountSid,
      "to": to,
      "channel": channel,
      "status": status,
      "valid": valid,
      "amount": amount,
      "payee": payee,
      "dateCreated": dateCreated?.toIso8601String(),
      "dateUpdated": dateUpdated?.toIso8601String(),
    };
  }
}
