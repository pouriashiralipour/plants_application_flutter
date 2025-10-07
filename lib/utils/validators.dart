import 'iran_contact.dart';

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
    final value = (v ?? '').trim();
    if (v == null || v.trim().isEmpty) {
      return 'شماره موبایل خود را وارد کنید';
    }
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
    final value = (v ?? '').trim();
    if (v == null || v.trim().isEmpty) {
      return 'شماره موبایل یا ایمیل خود را وارد کنید';
    }
    if (value.contains('@')) {
      if (!isValidEmail(value)) {
        return 'ایمیل را به‌درستی وارد کنید';
      }
    } else {
      if (!isValidIranPhone(value)) {
        return 'شماره موبایل را به‌درستی وارد کنید ';
      }
    }
    return null;
  }
}
