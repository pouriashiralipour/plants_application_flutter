import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:full_plants_ecommerce_app/core/config/app_constants.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: UrlInfo.baseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));

    _dio.interceptors.add(_AuthInterceptor(authStorage: AuthStorage.I));

    if (!kIsWeb) {
      final adapter = _dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.onHttpClientCreate = (client) {
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
    }

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  static final ApiClient I = ApiClient._internal();

  late final CookieJar _cookieJar;
  late final Dio _dio;

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor({required this.authStorage});

  final AuthStorage authStorage;

  Future<bool>? _refreshing;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final is401 = statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains(UrlInfo.refreshToken);

    if (!is401 || isRefreshCall) {
      handler.next(err);
      return;
    }

    try {
      _refreshing ??= _refreshIfPossible();
      final ok = await _refreshing!;
      _refreshing = null;

      if (!ok) {
        await authStorage.clear();
        handler.next(err);
        return;
      }

      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      await authStorage.clear();
      handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final (access, _) = await authStorage.readTokens();

    if (access != null && access.isNotEmpty) {
      options.headers['Authorization'] = 'JWT $access';
    }

    handler.next(options);
  }

  Future<bool> _refreshIfPossible() async {
    final (_, refresh) = await authStorage.readTokens();
    if (refresh == null || refresh.isEmpty) {
      return false;
    }

    try {
      final dio = Dio(
        BaseOptions(baseUrl: UrlInfo.baseUrl, headers: {'Content-Type': 'application/json'}),
      );

      final response = await dio.post(UrlInfo.refreshToken, data: {'refresh': refresh});

      final data = response.data;
      final access = data['access'] as String?;
      final newRefresh = (data['refresh'] as String?) ?? refresh;

      if (access == null || access.isEmpty) {
        return false;
      }

      await authStorage.saveTokens(access: access, refresh: newRefresh);

      return true;
    } on DioException {
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions ro) {
    final dio = ApiClient.I.dio;
    return dio.request<dynamic>(
      ro.path,
      data: ro.data,
      queryParameters: ro.queryParameters,
      options: Options(
        method: ro.method,
        headers: ro.headers,
        responseType: ro.responseType,
        contentType: ro.contentType,
        followRedirects: ro.followRedirects,
        validateStatus: ro.validateStatus,
        receiveDataWhenStatusError: ro.receiveDataWhenStatusError,
      ),
    );
  }
}
