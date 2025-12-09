import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_result.dart';

import '../../../profile/data/models/profile_form_models.dart';
import '../../../profile/data/models/profile_models.dart';
import '../../../../core/config/app_constants.dart';

class ProfileApi {
  final Dio _dio = ApiClient.I.dio;

  Future<ApiResult<UserProfile>> complete(
    ProfileCompleteModels m, {
    File? avatarFile,
    String avatarFieldName = 'profile_pic',
  }) async {
    try {
      final map = m.toJson();
      final formMap = <String, dynamic>{...map};

      if (avatarFile != null) {
        formMap[avatarFieldName] = await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        );
      }
      final data = avatarFile == null ? map : FormData.fromMap(formMap);

      final r = await _dio.patch(
        UrlInfo.profileCompleteUrl,
        data: data,
        options: Options(
          headers: {
            if (avatarFile != null) 'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );

      if (r.statusCode == 200 || r.statusCode == 201) {
        return ApiResult(true, data: UserProfile.fromJson(r.data as Map<String, dynamic>));
      }
      return ApiResult(
        false,
        error: extractErrorMessage(data: r.data, fallback: 'خطا در تکمیل پروفایل'),
      );
    } on DioException catch (e) {
      return ApiResult(
        false,
        error: extractErrorMessage(data: e.response?.data, fallback: e.message),
      );
    }
  }
}
