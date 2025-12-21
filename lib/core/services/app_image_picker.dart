import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_colors.dart';

enum AppImagePickStatus { picked, cancelled, permissionDenied, error }

class AppImagePickResult {
  const AppImagePickResult._(this.status, {this.file, this.message});

  final AppImagePickStatus status;
  final File? file;
  final String? message;

  factory AppImagePickResult.picked(File f) =>
      AppImagePickResult._(AppImagePickStatus.picked, file: f);

  factory AppImagePickResult.cancelled() =>
      const AppImagePickResult._(AppImagePickStatus.cancelled);

  factory AppImagePickResult.permissionDenied([String? msg]) =>
      AppImagePickResult._(AppImagePickStatus.permissionDenied, message: msg);

  factory AppImagePickResult.error(String msg) =>
      AppImagePickResult._(AppImagePickStatus.error, message: msg);
}

class AppImagePicker {
  AppImagePicker._();

  static final ImagePicker _picker = ImagePicker();

  static Future<AppImagePickResult> pickAndCrop({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
    CropStyle cropStyle = CropStyle.rectangle,
    CropAspectRatio? aspectRatio,
    int compressQuality = 92,
  }) async {
    final ok = await _requestPermission(source);
    if (!ok) return AppImagePickResult.permissionDenied('اجازه دسترسی داده نشد');

    try {
      final XFile? picked = await _picker.pickImage(source: source);
      if (picked == null) return AppImagePickResult.cancelled();

      final CroppedFile? cropped = await _crop(
        context: context,
        sourcePath: picked.path,
        cropStyle: cropStyle,
        aspectRatio: aspectRatio,
        compressQuality: compressQuality,
      );

      if (cropped == null) return AppImagePickResult.cancelled();
      return AppImagePickResult.picked(File(cropped.path));
    } catch (e) {
      return AppImagePickResult.error('خطا در انتخاب/برش تصویر: $e');
    }
  }

  static Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final camera = await Permission.camera.request();
      return camera.isGranted;
    }

    final photos = await Permission.photos.request();
    if (photos.isGranted) return true;

    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  static Future<CroppedFile?> _crop({
    required BuildContext context,
    required String sourcePath,
    required CropStyle cropStyle,
    required int compressQuality,
    CropAspectRatio? aspectRatio,
  }) async {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final toolbarColor = isLight ? AppColors.white : AppColors.dark1;
    final toolbarWidgetColor = isLight ? AppColors.grey900 : AppColors.white;

    return ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: aspectRatio,
      compressQuality: compressQuality,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'برش تصویر',
          toolbarColor: toolbarColor,
          toolbarWidgetColor: toolbarWidgetColor,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: cropStyle == CropStyle.circle || aspectRatio != null,
          hideBottomControls: false,
          cropStyle: cropStyle,
        ),
        IOSUiSettings(
          title: 'برش تصویر',
          aspectRatioLockEnabled: cropStyle == CropStyle.circle || aspectRatio != null,
        ),
      ],
    );
  }
}
