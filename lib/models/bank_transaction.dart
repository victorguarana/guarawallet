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

  void changePaid() {
    alreadyPaid = !alreadyPaid;
    if (alreadyPaid) {
      payDay = DateTime.now();
    } else {
      payDay = null;
    }
  }

  BankTransaction clone() {
    return BankTransaction(
        id: id,
        createdWhen: createdWhen,
        payDay: payDay,
        alreadyPaid: alreadyPaid,
        name: name,
        value: value,
        account: account);
  }
}
