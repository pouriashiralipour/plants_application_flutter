import 'package:dio/dio.dart';

import '../../../profile/data/models/profile_models.dart';
import '../models/auth_tokens_model.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';

class AuthApi {
  final _dio = ApiClient.I.dio;

  Future<ApiResult<AuthPayload>> login({required String login, required String password}) async {
    try {
      final response = await _dio.post(
        UrlInfo.loginUrl,
        data: {'login': login, 'password': password},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult(
          true,
          data: AuthPayload.fromJson(response.data as Map),
          message: extractServerMessage(response.data),
          status: response.statusCode,
          raw: response.data,
        );
      }
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'نام کاربری یا رمز عبور نادرست است',
        ),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      final st = e.response?.statusCode;
      final body = e.response?.data;
      return ApiResult(
        false,
        error: extractErrorMessage(status: st, data: body, fallback: e.message),
        status: st,
        raw: body,
      );
    }
  }

  Future<ApiResult<AuthPayload>> refresh(String refreshToken) async {
    try {
      final response = await _dio.post(UrlInfo.refreshToken, data: {'refresh': refreshToken});
      if (response.statusCode == 200) {
        final access = response.data['access'] as String?;
        final refresh = response.data['refresh'] as String? ?? '';
        final payload = AuthPayload(
          tokens: AuthTokens(access: access!, refresh: refresh),
        );
        return ApiResult(
          true,
          data: payload,
          status: 200,
          raw: response.data,
          message: extractServerMessage(response.data),
        );
      }
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'نوسازی توکن ناموفق بود',
        ),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
        status: e.response?.statusCode,
        raw: e.response?.data,
      );
    }
  }

  Future<ApiResult<void>> requestOtp({required String target, required String purpose}) async {
    try {
      final response = await _dio.post(
        UrlInfo.otpRequestUrl,
        data: {'target': target, 'purpose': purpose},
      );
      if (response.statusCode == 200 || response.statusCode == 201) return const ApiResult(true);
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'درخواست نامعتبر بود',
        ),
        message: extractServerMessage(response.data),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      final st = e.response?.statusCode;
      final body = e.response?.data;
      return ApiResult(
        false,
        error: extractErrorMessage(status: st, data: body, fallback: e.message),
        status: st,
        raw: body,
      );
    }
  }

  Future<ApiResult<void>> requestPasswordOtp({required String target}) async {
    try {
      final response = await _dio.post(UrlInfo.passwordResetRequestUrl, data: {'target': target});
      if (response.statusCode == 200 || response.statusCode == 201) return const ApiResult(true);
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'درخواست نامعتبر بود',
        ),
        message: extractServerMessage(response.data),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      final st = e.response?.statusCode;
      final body = e.response?.data;
      return ApiResult(
        false,
        error: extractErrorMessage(status: st, data: body, fallback: e.message),
        status: st,
        raw: body,
      );
    }
  }

  Future<ApiResult<void>> setNewPassword({
    required String resetToken,
    required String newPassword,
    String? confirmNewPassword,
  }) async {
    try {
      final response = await _dio.post(
        UrlInfo.setPasswordUrl,
        data: {
          'reset_token': resetToken,
          'password': newPassword,
          if (confirmNewPassword != null) 'password_confirm': confirmNewPassword,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204)
        return ApiResult(true, message: extractServerMessage(response.data));
      return ApiResult(
        false,
        error: extractErrorMessage(data: response.data, fallback: 'تغییر پسورد ناموفق بود'),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(data: e.response?.data, fallback: e.message),
      );
    }
  }

  Future<ApiResult<AuthPayload>> verifyOtp(String code) async {
    try {
      final response = await _dio.post(UrlInfo.otpVerifyUrl, data: {'code': code});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult(
          true,
          data: AuthPayload.fromJson(response.data as Map),
          status: response.statusCode,
          raw: response.data,
          message: extractServerMessage(response.data),
        );
      }
      ;
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'کد نامعتبر است',
        ),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      final st = e.response?.statusCode;
      final body = e.response?.data;
      return ApiResult(
        false,
        error: extractErrorMessage(status: st, data: body, fallback: e.message),
        status: st,
        raw: body,
      );
    }
  }

  Future<ApiResult<ResetTokenPayload>> verifyPasswordOtp({required String code}) async {
    try {
      final response = await _dio.post(UrlInfo.passwordResetVerifyUrl, data: {'code': code});
      if (response.statusCode == 200) {
        return ApiResult(
          message: extractServerMessage(response.data),
          true,
          data: ResetTokenPayload.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return ApiResult(
        false,
        error: extractErrorMessage(data: response.data, fallback: 'کد نامعتبر است'),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(data: e.response?.data, fallback: e.message),
      );
    }
  }

  Future<ApiResult<void>> requestChangeIdentifierOtp({required String target}) async {
    try {
      final response = await _dio.post(
        UrlInfo.changeIdentifierRequestUrl,
        data: {'target': target},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const ApiResult(true);
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'ارسال کد ناموفق بود',
        ),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
        status: e.response?.statusCode,
        raw: e.response?.data,
      );
    }
  }

  Future<ApiResult<UserProfile>> verifyChangeIdentifierOtp({required String code}) async {
    try {
      final response = await _dio.post(UrlInfo.changeIdentifierVerifyUrl, data: {'code': code});

      if (response.statusCode == 200 && response.data is Map) {
        return ApiResult(
          true,
          data: UserProfile.fromJson(Map<String, dynamic>.from(response.data as Map)),
          status: response.statusCode,
          raw: response.data,
        );
      }

      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'کد نامعتبر است',
        ),
        status: response.statusCode,
        raw: response.data,
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: e.response?.statusCode,
          data: e.response?.data,
          fallback: e.message,
        ),
        status: e.response?.statusCode,
        raw: e.response?.data,
      );
    }
  }
}
