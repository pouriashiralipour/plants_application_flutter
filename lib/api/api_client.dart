import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:full_plants_ecommerce_app/utils/constant.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: UrlInfo.baseUrl,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (c) => c != null && c < 500,
      ),
    )..httpClientAdapter = IOHttpClientAdapter();

    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  static final ApiClient I = ApiClient._internal();
  late final Dio _dio;
  final CookieJar _cookieJar = CookieJar();

  Dio get dio => _dio;

  Future<Response> postJson(String path, {Object? data, String? bearer}) {
    return _dio.post(path, data: data, options: _authOptions(bearer));
  }

  Future<Response> patchJson(String path, {Object? data, String? bearer}) {
    return _dio.patch(path, data: data, options: _authOptions(bearer));
  }

  Future<Response> multipartPatch(String path, {required FormData form, String? bearer}) {
    return _dio.patch(
      path,
      data: form,
      options: _authOptions(bearer, contentType: 'multipart/form-data'),
    );
  }

  Options _authOptions(String? jwt, {String? contentType}) {
    final headers = <String, String>{};
    if (contentType != null) headers['Content-Type'] = contentType;
    if (jwt != null && jwt.isNotEmpty) headers['Authorization'] = 'JWT $jwt';
    return Options(headers: headers);
  }
}
