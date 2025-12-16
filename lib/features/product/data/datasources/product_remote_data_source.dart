import 'package:dio/dio.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';

class ShopApi {
  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<List<CategoryModel>>> getCategories() async {
    try {
      final response = await _dio.get(UrlInfo.categoryUrl);

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<CategoryModel> categories = (response.data as List).map((e) {
            return CategoryModel.fromJson(e);
          }).toList();

          return ApiResult(true, data: categories);
        } else {
          return ApiResult(false, error: 'Invalid response format: expected List');
        }
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'خطا در دریافت دسته‌بندی‌ها',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    } catch (e) {
      return ApiResult(false, error: 'خطای غیرمنتظره در دریافت دسته‌بندی‌ها');
    }
  }

  Future<ApiResult<ProductModel>> getProduct(String id) async {
    try {
      final response = await _dio.get('${UrlInfo.productsUrl}/$id/');

      if (response.statusCode == 200) {
        final product = ProductModel.fromJson(response.data);
        return ApiResult(true, data: product);
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'خطا در دریافت محصول',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }

  Future<ApiResult<List<ProductModel>>> getProducts({
    String? search,
    String? category,
    String? ordering,
    int? page,
    int? priceMin,
    int? priceMax,
    int? rating,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (ordering != null && ordering.isNotEmpty) {
        queryParams['ordering'] = ordering;
      }

      if (page != null) queryParams['page'] = page;

      if (priceMin != null) queryParams['price_min'] = priceMin;
      if (priceMax != null) queryParams['price_max'] = priceMax;

      if (rating != null && rating > 0) {
        queryParams['rating'] = rating;
      }

      final response = await _dio.get(
        UrlInfo.productsUrl,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      if (response.statusCode == 200) {
        final List<ProductModel> products = (response.data as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return ApiResult(true, data: products);
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'خطا در دریافت محصولات',
        ),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
      );
    }
  }
}
