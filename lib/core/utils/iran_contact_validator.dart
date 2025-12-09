import 'dart:core';

final RegExp _iranPhoneRegex = RegExp(r'^(\+98|0)9\d{9}$');

final RegExp _emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");

bool isValidIranPhone(String input) {
  return _iranPhoneRegex.hasMatch(input.trim());
}

bool isValidEmail(String input) {
  return _emailRegex.hasMatch(input.trim());
}

String normalizeIranPhone(String value) {
  if (value.isEmpty) return value;
  final digits = value.replaceAll(RegExp(r'\D'), '');

  if (digits.length == 10 && digits.startsWith('9')) {
    return '+98$digits';
  }

  var t = digits;
  if (t.startsWith('98')) {
    t = t.substring(2);
  } else if (t.startsWith('0')) {
    t = t.substring(1);
  }

  if (t.startsWith('9') && t.length == 10) {
    return '+98$t';
  }
  return value;
}

String toEnglishDigits(String s) {
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  var out = s;
  for (var i = 0; i < fa.length; i++) {
    out = out.replaceAll(fa[i], en[i]);
  }
  return out;
}
