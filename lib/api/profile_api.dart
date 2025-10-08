import 'dart:io';

import 'package:dio/dio.dart';

import '../models/auth/profile_models.dart';
import '../utils/constant.dart';
import 'api_client.dart';
import 'api_result.dart';

class ProfileApi {
  final _dio = ApiClient.I.dio;

  Future<ApiResult<void>> complete(
    ProfileCompleteModels model, {
    required String accessToken,
    File? avatarFile,
    String avatarFieldName = 'profile_pic',
  }) async {
    try {
      Response response;
      if (avatarFile != null) {
        final form = FormData.fromMap({
          ...model.toJson(),
          avatarFieldName: await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          ),
        });
        response = await _dio.patch(
          UrlInfo.profileCompleteUrl,
          data: form,
          options: Options(
            headers: {'Authorization': 'JWT $accessToken', 'Content-Type': 'multipart/form-data'},
          ),
        );
      } else {
        response = await _dio.patch(
          UrlInfo.profileCompleteUrl,
          data: model.toJson(),
          options: Options(headers: {'Authorization': 'JWT $accessToken'}),
        );
      }
      if (response.statusCode == 200 || response.statusCode == 201) return const ApiResult(true);
      return ApiResult(
        false,
        error: extractErrorMessage(
          status: response.statusCode,
          data: response.data,
          fallback: 'خطا در تکمیل پروفایل',
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
}
