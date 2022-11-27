import 'package:intl/intl.dart';

class Util {
  static String formatToDate(DateTime dt) {
    DateFormat formater = DateFormat('yyyy-MM-dd');

    return formater.format(dt);
  }

  static String formatShow(DateTime dt) {
    DateFormat formater = DateFormat('dd/MM/yyyy');

    return formater.format(dt);
  }

  static String get currency =>
      NumberFormat.compactSimpleCurrency(locale: 'pt_Br').currencySymbol;

  static String formatCurrency(String value) {
    // Remove letters and other chars
    value = _removeLetters(value);
    value = _removeCommas(value);

    if (value.endsWith(',')) return value;

    try {
      value = value.replaceAll('.', '').replaceAll(',', '.');
      double valueDouble = double.parse(value);
      valueDouble = (double.parse(value) * 100).truncateToDouble() / 100;
      return NumberFormat.decimalPattern('pt_Br').format(valueDouble);
    } on FormatException {
      // TODO: Remove this print before build?
      print('Format Exception');
      return value;
    }
  }

  static String _removeLetters(String value) =>
      value.replaceAll(RegExp(r'[^0-9/,/.]'), '');

  static String _removeCommas(String value) {
    if (value.indexOf(',') != value.lastIndexOf(',')) {
      int index = value.lastIndexOf(',');
      return value.substring(0, index) + value.substring(index + 1);
    }
    return value;
  }
}
