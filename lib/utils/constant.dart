class UrlInfo {
  //  Android Emulator:
  static String baseUrl = 'http://10.0.2.2:8000/';
  // static String baseUrl = 'http://127.0.0.1:8000/';
  // static String baseUrl = 'http://<LAN-IP-OF-LAPTOP>:8000/';

  // OTP ENDPOINTS
  static String otpRequestUrl = 'auth/otp_request/';
  static String otpVerifyUrl = 'auth/otp_verify/';

  // PROFILE
  static String profileCompleteUrl = 'auth/profile_complete/';
  static String userProfile = 'auth/me/';

  // TOKENS
  static String refreshToken = 'api/token/refresh/';

  // LOGIN AND PASSOWRD
  static String loginUrl = 'auth/login/';
  static String passwordResetRequestUrl = 'auth/password_reset_request/';
  static String passwordResetVerifyUrl = 'auth/password_reset_verify/';
  static String setPasswordUrl = 'auth/password_reset_set/';
}
