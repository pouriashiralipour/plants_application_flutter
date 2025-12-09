extension FarsiNumberExtension on String {
  static const _en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  String get farsiNumber {
    var s = this;
    for (var i = 0; i < _en.length; i++) {
      s = s.replaceAll(_en[i], _fa[i]);
    }
    return s;
  }

  String get englishNumber {
    var s = this;
    for (var i = 0; i < _fa.length; i++) {
      s = s.replaceAll(_fa[i], _en[i]);
    }
    return s;
  }
}
