import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';
import 'package:path/path.dart' as p;

import '../../../profile/data/models/profile_form_models.dart';
import '../../../profile/data/models/profile_models.dart';
import '../../../../core/config/app_constants.dart';

class ProfileApi {
  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<UserProfile>> complete(ProfileCompleteModels model, {File? avatarFile}) async {
    try {
      final Map<String, dynamic> body = model.toJson();

      if (avatarFile != null) {
        body['profile_pic'] = await MultipartFile.fromFile(
          avatarFile.path,
          filename: p.basename(avatarFile.path),
        );
      }

      final formData = FormData.fromMap(body);

      final response = await _dio.patch(UrlInfo.profileCompleteUrl, data: formData);

      return ApiResult(
        true,
        data: UserProfile.fromJson(Map<String, dynamic>.from(response.data as Map)),
      );
    } catch (e) {
      return ApiResult(false, error: e.toString());
    }
  }

  Future<ApiResult<UserProfile>> edit({
    required Map<String, dynamic> fields,
    File? avatarFile,
  }) async {
    try {
      final Map<String, dynamic> body = {...fields};

      if (avatarFile != null) {
        body['profile_pic'] = await MultipartFile.fromFile(
          avatarFile.path,
          filename: p.basename(avatarFile.path),
        );
      }

      final formData = FormData.fromMap(body);
      final response = await _dio.patch(UrlInfo.profileCompleteUrl, data: formData);

      return ApiResult(
        true,
        data: UserProfile.fromJson(Map<String, dynamic>.from(response.data as Map)),
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
    } catch (e) {
      return ApiResult(false, error: e.toString());
    }
  }
}
