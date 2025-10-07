import 'dart:io';

import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:full_plants_ecommerce_app/models/otp_models.dart';
import 'package:full_plants_ecommerce_app/utils/constant.dart';

import '../models/profile_models.dart';

class OtpResult {
  const OtpResult(this.ok, {this.error, this.tokens, this.userId});

  final String? error;
  final bool ok;
  final AuthTokens? tokens;
  final int? userId;
}

class ProfileResult {
  const ProfileResult(this.ok, {this.error});

  final bool ok;
  final String? error;
}

class OtpServices {
  OtpServices() {
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    if (!_dio.interceptors.any((i) => i is CookieManager)) {
      _dio.interceptors.add(CookieManager(_sharedCookieJar));
    }
  }

  static final CookieJar _sharedCookieJar = CookieJar();

  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: UrlInfo.baseUrl,
            headers: {'Content-Type': 'application/json'},
            validateStatus: (code) => code != null && code < 500,
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.next(options),
            onResponse: (response, handler) => handler.next(response),
            onError: (e, handler) => handler.next(e),
          ),
        );

  Future<OtpResult> requestOtp(OtpRequestModels model) async {
    try {
      final response = await _dio.post(
        UrlInfo.baseUrl + UrlInfo.otpRequestUrl,
        data: model.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const OtpResult(true);
      }
      final msg = _extractErrorMessage(response.data) ?? 'درخواست نامعتبر بود';
      if (kDebugMode) debugPrint('OTP 4xx => ${response.statusCode} | $msg');
      return OtpResult(false, error: msg);
    } on DioException catch (e) {
      final msg =
          _extractErrorMessage(e.response?.data) ?? e.message ?? 'خطا در برقراری ارتباط با سرور';
      if (kDebugMode) {
        debugPrint('Full Error: $e');
        debugPrint('Type: ${e.type}');
        debugPrint('Status: ${e.response?.statusCode}');
        debugPrint('Body: ${e.response?.data}');
      }
      return OtpResult(false, error: msg);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected: $e');
      return const OtpResult(false, error: 'خطای ناشناخته رخ داد');
    }
  }

  Future<OtpResult> verifyOtp(OtpVerifyModels model) async {
    try {
      final response = await _dio.post(
        UrlInfo.baseUrl + UrlInfo.otpVerifyUrl,
        data: model.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data is Map ? response.data as Map : {};
        final tokens = (data['tokens'] is Map) ? AuthTokens.fromJson(data['tokens'] as Map) : null;
        final userId = data['user_id'] is int ? data['user_id'] as int : null;
        if (tokens == null || tokens.access.isEmpty || tokens.refresh.isEmpty) {
          return const OtpResult(false, error: 'پاسخ سرور فاقد توکن معتبر است');
        }
        return OtpResult(true, tokens: tokens, userId: userId);
      }
      final msg = _extractErrorMessage(response.data) ?? 'درخواست نامعتبر بود';
      if (kDebugMode) debugPrint('OTP 4xx => ${response.statusCode} | $msg');
      return OtpResult(false, error: msg);
    } on DioException catch (e) {
      final msg =
          _extractErrorMessage(e.response?.data) ?? e.message ?? 'خطا در برقراری ارتباط با سرور';
      if (kDebugMode) {
        debugPrint('Full Error: $e');
        debugPrint('Type: ${e.type}');
        debugPrint('Status: ${e.response?.statusCode}');
        debugPrint('Body: ${e.response?.data}');
      }
      return OtpResult(false, error: msg);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected: $e');
      return const OtpResult(false, error: 'خطای ناشناخته رخ داد');
    }
  }
}

class ProfileServices {
  ProfileServices() {
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) => handler.next(response),
        onError: (e, handler) => handler.next(e),
      ),
    );
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: UrlInfo.baseUrl,
      headers: {'Content-Type': 'application/json'},
      validateStatus: (code) => code != null && code < 500,
    ),
  )..httpClientAdapter = IOHttpClientAdapter();

  Future<ProfileResult> completeProfile(
    ProfileCompleteModels model, {
    required String accessToken,
    File? avatarFile,
    String avatarFieldName = 'profile_pic',
  }) async {
    try {
      final String url = UrlInfo.baseUrl + UrlInfo.profileCompleteUrl;

      final headers = <String, String>{'Authorization': 'JWT $accessToken'};

      Response response;

      if (avatarFile != null) {
        final fileName = avatarFile.path.split(Platform.pathSeparator).last;
        final form = FormData.fromMap({
          ...model.toJson(),
          avatarFieldName: await MultipartFile.fromFile(avatarFile.path, filename: fileName),
        });

        response = await _dio.patch(
          url,
          data: form,
          options: Options(headers: headers, contentType: 'multipart/form-data'),
        );
      } else {
        response = await _dio.patch(
          url,
          data: model.toJson(),
          options: Options(headers: {...headers, 'Content-Type': Headers.jsonContentType}),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const ProfileResult(true);
      }

      final msg = _extractErrorMessage(response.data) ?? 'درخواست نامعتبر بود';
      if (kDebugMode) {
        debugPrint('PROFILE 4xx => ${response.statusCode} | $msg');
      }
      return ProfileResult(false, error: msg);
    } on DioException catch (e) {
      final msg =
          _extractErrorMessage(e.response?.data) ?? e.message ?? 'خطا در برقراری ارتباط با سرور';
      if (kDebugMode) {
        debugPrint('Profile Error: $e');
        debugPrint('Type: ${e.type}');
        debugPrint('Status: ${e.response?.statusCode}');
        debugPrint('Body: ${e.response?.data}');
      }
      return ProfileResult(false, error: msg);
    } catch (e) {
      if (kDebugMode) debugPrint('Profile Unexpected: $e');
      return const ProfileResult(false, error: 'خطای ناشناخته رخ داد');
    }
  }
}

String? _extractErrorMessage(dynamic data) {
  if (data == null) return null;

  if (data is Map) {
    final keys = ['target', 'email', 'phone', 'detail', 'message', 'error', 'non_field_errors'];
    for (final k in keys) {
      final v = data[k];
      if (v is List && v.isNotEmpty) return v.first.toString();
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return data.toString();
  }
  if (data is List && data.isNotEmpty) return data.first.toString();
  if (data is String && data.trim().isNotEmpty) return data.trim();
  return null;
}
