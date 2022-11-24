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
}
