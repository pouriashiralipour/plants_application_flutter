import 'package:dio/dio.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import '../models/address_model.dart';

class AddressApi {
  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<AddressModel>> create(AddressModel draft) async {
    try {
      final response = await _dio.post(UrlInfo.addressUrl, data: draft.toCreateJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data is Map) {
          return ApiResult(
            true,
            data: AddressModel.fromJson(Map<String, dynamic>.from(response.data as Map)),
          );
        }
        return ApiResult(false, error: 'فرمت پاسخ ایجاد آدرس نامعتبر است.');
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'ایجاد آدرس ناموفق بود',
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

  Future<ApiResult<List<AddressModel>>> list() async {
    try {
      final response = await _dio.get(UrlInfo.addressUrl);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          final items = data
              .map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          return ApiResult(true, data: items);
        }
        return ApiResult(false, error: 'فرمت پاسخ آدرس‌ها نامعتبر است.');
      }
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'دریافت آدرس‌ها ناموفق بود',
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
