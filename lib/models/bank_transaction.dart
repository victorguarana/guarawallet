class BankTransaction {
  int? id;
  String name;
  double value;
  String account;

  BankTransaction({
    this.id,
    required this.name,
    required this.value,
    required this.account,
  });
}
