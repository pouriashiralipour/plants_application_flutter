import 'package:intl/intl.dart';

extension PriceCommaSeperatorExtention on String {
  String get priceFormatter {
    final numeric = replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.parse(numeric);
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }
}
