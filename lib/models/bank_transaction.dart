import 'package:guarawallet/utils/util.dart';

class BankTransaction {
  int? id;
  String name;
  double value;
  String account;
  DateTime? createdWhen;
  DateTime? payDay;
  bool alreadyPaid;

  BankTransaction({
    this.id,
    this.createdWhen,
    this.payDay,
    required this.alreadyPaid,
    required this.name,
    required this.value,
    required this.account,
  });

  String createdWhenFormatted() {
    return Util.formatShow(createdWhen!);
  }

  String payDayFormatted() {
    if (payDay != null) {
      return Util.formatShow(payDay!);
    }
    return '-';
  }
}
