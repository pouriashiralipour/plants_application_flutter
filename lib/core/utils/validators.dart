import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';

import 'iran_contact_validator.dart';

class Validators {
  static String? requiredBlankValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'شماره موبایل خود را وارد کنید';
    }
    return null;
  }

  static String? requiredEmailValidator(String? v) {
    final value = (v ?? '').trim();
    if (v == null || v.trim().isEmpty) {
      return 'ایمیل خود را وارد کنید';
    }
    if (value.contains('@')) {
      if (!isValidEmail(value)) {
        return 'ایمیل را به‌درستی وارد کنید';
      }
    }
    return null;
  }

  static String? requiredMobileValidator(String? v) {
    final raw = (v ?? '').trim();

    if (raw == null || raw.trim().isEmpty) {
      return 'شماره موبایل خود را وارد کنید';
    }

    final value = raw.englishNumber;
    if (!isValidIranPhone(value)) {
      return 'شماره موبایل را به‌درستی وارد کنید ';
    }
    return null;
  }

  static String? requiredPasswordValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'رمزعبور خود را وارد کنید';
    }
    if (v.trim().length < 8) {
      return 'رمز عبور شما باید حداقل 8 کارکتر باشد';
    }
    return null;
  }

  static String? requiredTargetValidator(String? v) {
    final raw = (v ?? '').trim();
    if (raw.isEmpty) {
      return 'شماره موبایل یا ایمیل خود را وارد کنید';
    }

    if (raw.contains('@')) {
      if (!isValidEmail(raw)) {
        return 'ایمیل را به‌درستی وارد کنید';
      }
    } else {
      final value = raw.englishNumber;
      if (!isValidIranPhone(value)) {
        return 'شماره موبایل را به‌درستی وارد کنید ';
      }
    }
    return null;
  }
}
