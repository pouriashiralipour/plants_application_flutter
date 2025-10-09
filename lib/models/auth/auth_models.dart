class AuthPayload {
  AuthPayload({required this.tokens, this.userId, this.detail});

  factory AuthPayload.fromJson(Map json) => AuthPayload(
    tokens: AuthTokens.fromJson(json['tokens'] as Map),
    userId: json['user_id'] as String?,
    detail: json['detail'] as String?,
  );

  final String? detail;
  final AuthTokens tokens;
  final String? userId;
}

class AuthTokens {
  const AuthTokens({required this.access, required this.refresh});

  factory AuthTokens.fromJson(Map json) =>
      AuthTokens(access: json['access'] as String, refresh: json['refresh'] as String);

  final String access;
  final String refresh;
}

class ResetTokenPayload {
  final String resetToken;
  final String? detail;
  ResetTokenPayload({required this.resetToken, this.detail});

  factory ResetTokenPayload.fromJson(Map json) => ResetTokenPayload(
    resetToken: json['reset_token'] as String,
    detail: json['detail'] as String?,
  );
}
