import 'package:flutter/material.dart';
import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BankTransactionRepository extends ChangeNotifier {
  static const String tableSQL =
      'CREATE TABLE $_tablename ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT NOT NULL, $_value REAL NOT NULL, $_account TEXT NOT NULL) ';
  static const String _tablename = 'transactionTable';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _value = 'value';
  static const String _account = 'account';

  List<BankTransaction> allTransactions = [];

  save(BankTransaction bankTransaction) async {
    final Database database = await getDataBase();

    // TODO: Move this logic to other class?
    await database.transaction((txn) async {
      await txn.insert(_tablename, toMap(bankTransaction));
      await AccountsRepository()
          .debitAccount(txn, bankTransaction.value, bankTransaction.account);
    });

    allTransactions.add(bankTransaction);
    notifyListeners();
  }

  Future<List<BankTransaction>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    return toList(result);
  }

  Future<void> loadAll() async {
    allTransactions = await findAll();

    notifyListeners();
  }

  Future<List<BankTransaction>> find(int id) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    return toList(result);
  }

  List<BankTransaction> toList(List<Map<String, dynamic>> transactionMaps) {
    final List<BankTransaction> bankTransactions = [];

    for (Map<String, dynamic> transactionMap in transactionMaps) {
      final BankTransaction bankTransaction = BankTransaction(
        id: transactionMap[_id],
        name: transactionMap[_name],
        value: transactionMap[_value],
        account: transactionMap[_account],
      );
      bankTransactions.add(bankTransaction);
    }

    return bankTransactions;
  }

  Map<String, dynamic> toMap(BankTransaction bankTransaction) {
    final Map<String, dynamic> map = {};
    map[_id] = bankTransaction.id;
    map[_name] = bankTransaction.name;
    map[_value] = bankTransaction.value;
    map[_account] = bankTransaction.account;
    return map;
  }

  deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tablename);
  }
}