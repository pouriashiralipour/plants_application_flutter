import 'package:dio/dio.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/wishlist_item_model.dart';

class WishlistApi {
  WishlistApi._();
  static final WishlistApi I = WishlistApi._();

  Dio get _dio => ApiClient.I.dio;

  Future<ApiResult<List<WishlistItemModel>>> getAll() async {
    try {
      final response = await _dio.get(UrlInfo.wishlistUrl);

      if (response.statusCode == 200) {
        final List data = response.data as List;
        final items = data
            .map((e) => WishlistItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        return ApiResult(true, data: items, status: response.statusCode);
      }
      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(status: response.statusCode, data: response.data),
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

  Future<ApiResult<WishlistItemModel>> add(String productId) async {
    try {
      final response = await _dio.post(UrlInfo.wishlistUrl, data: {'product_id': productId});

      if (response.statusCode == 201 || response.statusCode == 200) {
        final item = WishlistItemModel.fromJson(Map<String, dynamic>.from(response.data as Map));
        return ApiResult(true, data: item, status: response.statusCode);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(status: response.statusCode, data: response.data),
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

  Future<ApiResult<void>> remove(String wishlistItemId) async {
    try {
      final response = await _dio.delete('${UrlInfo.wishlistUrl}$wishlistItemId/');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return const ApiResult(true);
      }

      return ApiResult(
        false,
        status: response.statusCode,
        error: extractErrorMessage(status: response.statusCode, data: response.data),
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
