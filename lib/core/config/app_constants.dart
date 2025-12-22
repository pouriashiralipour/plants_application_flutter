class UrlInfo {
  //  Android Emulator:
  static String baseUrl = 'http://10.0.2.2:8000/';

  static String cartsUrl = 'carts/';
  static String categoryUrl = 'categories/';
  // LOGIN AND PASSOWRD
  static String loginUrl = 'auth/login/';

  // static String baseUrl = 'http://127.0.0.1:8000/';
  // static String baseUrl = 'http://<LAN-IP-OF-LAPTOP>:8000/';

  // OTP ENDPOINTS
  static String otpRequestUrl = 'auth/otp_request/';

  static String otpVerifyUrl = 'auth/otp_verify/';
  static String passwordResetRequestUrl = 'auth/password_reset_request/';
  static String passwordResetVerifyUrl = 'auth/password_reset_verify/';
  static const changeIdentifierRequestUrl = '/auth/change_identifier_request/';
  static const changeIdentifierVerifyUrl = '/auth/change_identifier_verify/';

  // Shop
  static String productsUrl = 'products/';

  // PROFILE
  static String profileCompleteUrl = 'auth/profile_complete/';
  static String addressUrl = 'addresses/';

  // TOKENS
  static String refreshToken = 'api/token/refresh/';

  static String setPasswordUrl = 'auth/password_reset_set/';
  static String userProfile = 'auth/me/';
  static String wishlistUrl = 'wishlists/';

  static String cartItemsUrl(String cartId) => 'carts/$cartId/items/';

  static String productReview(String productId) => '${productsUrl}$productId/reviews/';
  static String productReviewLike(String productId, String reviewId) =>
      '${productReview(productId)}$reviewId/like/';
}
