class OtpRequestModels {
  OtpRequestModels({this.target, this.purpose = 'register'});

  String? purpose;
  String? target;

  Map<String, dynamic> toJson() => {'target': target, 'purpose': purpose};
}

class OtpVerifyModels {
  OtpVerifyModels({required this.code});

  String? code;

  Map<String, dynamic> toJson() => {'code': code};
}

class AuthTokens {
  final String access;
  final String refresh;

  const AuthTokens({required this.access, required this.refresh});

  factory AuthTokens.fromJson(Map<dynamic, dynamic> json) {
    return AuthTokens(access: json['access'] as String, refresh: json['refresh'] as String);
  }
}
