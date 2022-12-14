class Account {
  int? id;
  String name;
  double currentBalance;
  double expectedBalance;

  Account({
    this.id,
    required this.name,
    required this.currentBalance,
    required this.expectedBalance,
  });

  void movement(double value, bool alreadyPaid) {
    expectedBalance += value;
    if (alreadyPaid) {
      currentBalance += value;
    }
  }

  void payTransaction(double value, bool alreadyPaid) {
    if (alreadyPaid) {
      value = value * -1;
    }
    currentBalance += value;
  }
}
