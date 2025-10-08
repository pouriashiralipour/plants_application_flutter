import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:full_plants_ecommerce_app/utils/constant.dart';

import '../auth/auth_repository.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: UrlInfo.baseUrl,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (c) => c != null && c < 500,
      ),
    )..httpClientAdapter = IOHttpClientAdapter();
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(_AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: true, error: true),
    );
  }

  static final ApiClient I = ApiClient._internal();

  final CookieJar _cookieJar = CookieJar();
  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response> multipartPatch(String path, {required FormData form, String? jwt}) {
    return _dio.patch(
      path,
      data: form,
      options: _authOptions(jwt, contentType: 'multipart/form-data'),
    );
  }

  Future<Response> patchJson(String path, {Object? data, String? jwt}) {
    return _dio.patch(path, data: data, options: _authOptions(jwt));
  }

  Future<Response> postJson(String path, {Object? data, String? jwt}) {
    return _dio.post(path, data: data, options: _authOptions(jwt));
  }

  Options _authOptions(String? jwt, {String? contentType}) {
    final headers = <String, String>{};
    if (contentType != null) headers['Content-Type'] = contentType;
    if (jwt != null && jwt.isNotEmpty) headers['Authorization'] = 'JWT $jwt';
    return Options(headers: headers);
  }
}

class _AuthInterceptor extends Interceptor {
  Future<bool>? _refreshing;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains('/api/token/refresh/');
    if (!is401 || isRefreshCall) return handler.next(err);

    try {
      _refreshing ??= AuthRepository.I.refreshIfPossible();
      final ok = await _refreshing!;
      _refreshing = null;

      if (ok) {
        final req = await _retry(err.requestOptions);
        return handler.resolve(req);
      } else {
        await AuthRepository.I.logout();
        return handler.next(err);
      }
    } catch (_) {
      _refreshing = null;
      await AuthRepository.I.logout();
      return handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final t = AuthRepository.I.tokens;
    if (t != null) {
      options.headers['Authorization'] = 'JWT ${t.access}';
    }
    handler.next(options);
  }

  Future<Response> _retry(RequestOptions ro) {
    final dio = ApiClient.I.dio;
    return dio.request(
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
