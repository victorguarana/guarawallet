import 'package:flutter/material.dart';
import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/models/account.dart';

class AccountsRepository extends ChangeNotifier {
  List<Account> allAccounts = [];
  double generalCurrentBalance = 0;
  double generalExpectedBalance = 0;

  Account findByName(String accountName) {
    return allAccounts.singleWhere((account) => account.name == accountName);
  }

  void addLocal(Account account) {
    allAccounts.add(account);
    generalCurrentBalance += account.currentBalance;
    generalExpectedBalance += account.expectedBalance;

    notifyListeners();
  }

  void updateAllGeneral(double value, bool alreadyPaid) {
    generalExpectedBalance += value;

    if (alreadyPaid) {
      generalCurrentBalance += value;
    }

    notifyListeners();
  }

  void updateCurrent(double value, bool alreadyPaid) {
    if (!alreadyPaid) {
      value = value * -1;
    }
    generalCurrentBalance += value;

    notifyListeners();
  }

  void removeLocal(Account account) {
    allAccounts.remove(account);
    generalCurrentBalance -= account.currentBalance;
    generalExpectedBalance -= account.expectedBalance;

    notifyListeners();
  }

  Future<void> reloadAll() async {
    allAccounts = await AccountDAO.findAll();

    generalCurrentBalance = 0;
    generalExpectedBalance = 0;
    for (Account account in allAccounts) {
      generalCurrentBalance += account.currentBalance;
      generalExpectedBalance += account.expectedBalance;
    }

    notifyListeners();
  }
}
