import 'package:flutter/material.dart';
import 'package:guarawallet/data/bank_transaction_dao.dart';
import 'package:guarawallet/models/bank_transaction.dart';

class BankTransactionsRepository extends ChangeNotifier {
  List<BankTransaction> allTransactions = [];

  void addLocal(BankTransaction bankTransaction) {
    allTransactions.add(bankTransaction);
    notifyListeners();
  }

  void switchAlreadyPaidLocal(BankTransaction bankTransaction) {
    bankTransaction.changePaid();
    notifyListeners();
  }

  void removeLocal(BankTransaction bankTransaction) {
    allTransactions.remove(bankTransaction);
    notifyListeners();
  }

  void removeLocalByAccount(String accountName) {
    allTransactions
        .removeWhere((transaction) => transaction.account == accountName);
    notifyListeners();
  }

  Future<void> loadAll() async {
    allTransactions = await BankTransactionDAO.findAll();

    notifyListeners();
  }
}
