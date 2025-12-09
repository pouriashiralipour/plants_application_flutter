import 'package:dio/dio.dart';
import 'package:full_plants_ecommerce_app/core/config/app_constants.dart';

import '../../../profile/data/models/profile_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';

class UserApi {
  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<UserProfile>> me() async {
    try {
      final response = await _dio.get(UrlInfo.userProfile);
      if (response.statusCode == 200 && response.data is Map) {
        return ApiResult(true, data: UserProfile.fromJson(response.data as Map));
      }
      return ApiResult(
        false,
        error: extractErrorMessage(data: response.data, fallback: 'دریافت پروفایل ناموفق بود'),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(data: e.response?.data, fallback: e.message),
      );
    }
  }
}
