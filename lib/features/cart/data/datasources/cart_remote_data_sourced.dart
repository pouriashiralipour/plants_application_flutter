import 'package:dio/dio.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/cart_model.dart';

class CartApi {
  CartApi._();

  static final CartApi I = CartApi._();

  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<void>> addItem({
    required String cartId,
    required String productId,
    int quantity = 1,
  }) async {
    try {
      final response = await _dio.post(
        UrlInfo.cartItemsUrl(cartId),
        data: {'product': productId, 'quantity': quantity},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResult(true, status: response.statusCode);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'افزودن به سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<void>> clearCart(String cartId) async {
    try {
      final response = await _dio.delete('${UrlInfo.cartsUrl}$cartId/');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return const ApiResult(true);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'حذف سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<CartModel>> createCart() async {
    try {
      final response = await _dio.post(UrlInfo.cartsUrl);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map) {
          final cart = CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
          return ApiResult(true, data: cart, status: response.statusCode);
        }
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'ساخت سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<CartModel>> getCart(String cartId) async {
    try {
      final response = await _dio.get('${UrlInfo.cartsUrl}$cartId/');

      if (response.statusCode == 200 && response.data is Map) {
        final cart = CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
        return ApiResult(true, data: cart, status: response.statusCode);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'دریافت سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<void>> removeItem({required String cartId, required String itemId}) async {
    try {
      final response = await _dio.delete('${UrlInfo.cartItemsUrl(cartId)}$itemId/');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return const ApiResult(true);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'حذف آیتم از سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<void>> updateItem({
    required String cartId,
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.patch(
        '${UrlInfo.cartItemsUrl(cartId)}$itemId/',
        data: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return ApiResult(true, status: response.statusCode);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'به‌روزرسانی سبد خرید ناموفق بود',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        status: e.response?.statusCode,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }
}
