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
}
