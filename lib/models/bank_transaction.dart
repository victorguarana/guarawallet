import 'package:guarawallet/utils/util.dart';

class BankTransaction {
  int? id;
  String name;
  double value;
  String account;
  DateTime? createdWhen;

  BankTransaction({
    this.id,
    this.createdWhen,
    required this.name,
    required this.value,
    required this.account,
  });

  String createdWhenFormatted() {
    return Util.formatShow(createdWhen!);
  }
}
