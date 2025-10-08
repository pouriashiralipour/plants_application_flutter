import 'otp_models.dart';

class LoginResponseModel {
  LoginResponseModel(this.tokens, {this.userId, this.detail});

  AuthTokens? tokens;
  int? userId;

  String? detail;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    tokens = AuthTokens.fromJson(json['tokens']);
    detail = json['detail'];
    userId = json['user_id'];
  }
}
