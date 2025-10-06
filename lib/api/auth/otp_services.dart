import 'dart:io';

import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:full_plants_ecommerce_app/models/otp_models.dart';
import 'package:full_plants_ecommerce_app/utils/constant.dart';

class OtpServices {
  Future<bool> requestOtp(OtpRequestModels model) async {
    bool returnResponse = false;
    Dio dio = Dio();
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    try {
      var response = await dio.post(
        UrlInfo.baseUrl + UrlInfo.otpRequestUrl,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.userAgentHeader: 'FlutterApp/1.0',
          },
        ),
      );

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.data}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        returnResponse = true;
      }
    } on DioException catch (e) {
      debugPrint('Full Error: ${e.toString()}');
      debugPrint('Error Type: ${e.type}');
      if (e.response != null) {
        debugPrint('Error Status: ${e.response?.statusCode}');
        debugPrint('Error Body: ${e.response?.data}');
      } else {
        debugPrint('No Response - Check Network: ${e.message ?? 'Unknown'}');
      }
      returnResponse = false;
    }

    return returnResponse;
  }
}
