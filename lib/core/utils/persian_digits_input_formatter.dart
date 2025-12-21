import 'package:flutter/services.dart';
import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';

class PersianDigitsTextInputFormatter extends TextInputFormatter {
  const PersianDigitsTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final converted = newValue.text.farsiNumber;
    if (converted == newValue.text) return newValue;

    return newValue.copyWith(
      text: converted,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
