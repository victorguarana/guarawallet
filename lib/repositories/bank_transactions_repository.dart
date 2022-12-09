import 'package:flutter/material.dart';
import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/utils/util.dart';
import 'package:sqflite/sqlite_api.dart';

class BankTransactionsRepository extends ChangeNotifier {
  static const String tableSQL = '''CREATE TABLE $_tablename 
        ($_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_name TEXT NOT NULL,
        $_value REAL NOT NULL,
        $_account TEXT NOT NULL,
        $_payDay DATE,
        $_alreadyPaid BOOLEAN NOT NULL)''';
  static const String _tablename = 'transactionTable';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _value = 'value';
  static const String _account = 'account';
  static const String _payDay = 'pay_day';
  static const String _alreadyPaid = 'already_paid';

  List<BankTransaction> allTransactions = [];

  void insertDB(Batch batch, BankTransaction bankTransaction) {
    batch.insert(_tablename, toMap(bankTransaction));
  }

  void addLocal(BankTransaction bankTransaction) {
    allTransactions.add(bankTransaction);
    notifyListeners();
  }

  void switchAlreadyPaid(Batch batch, BankTransaction bankTransaction) {
    batch.update(_tablename, toMap(bankTransaction),
        where: '$_id = ?', whereArgs: [bankTransaction.id]);
  }

  void switchAlreadyPaidLocal(BankTransaction bankTransaction) {
    bankTransaction.changePaid();
    notifyListeners();
  }

  void deleteDB(Batch batch, BankTransaction bankTransaction) {
    batch.delete(_tablename, where: '$_id = ${bankTransaction.id}');
  }

  void removeLocal(BankTransaction bankTransaction) {
    allTransactions.remove(bankTransaction);
    notifyListeners();
  }

  void deleteAllFromAccountDB(Batch batch, String accountName) {
    batch.delete(_tablename, where: '$_account = \'$accountName\'');
  }

  void deleteAllFromAccountLocal(String accountName) {
    allTransactions
        .removeWhere((transaction) => transaction.account == accountName);
    notifyListeners();
  }

  Future<List<BankTransaction>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tablename,
        orderBy: '$_payDay DESC, $_id NULLS FIRST');
    // TODO: Put this back when pagination is ready
    // where:
    //     '(strftime(\'%m\', $_payDay) = strftime(\'%m\', \'now\', \'localtime\') AND strftime(\'%Y\', $_payDay) = strftime(\'%Y\', \'now\', \'localtime\')) OR $_payDay IS NULL');
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

  Future<void> deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tablename);
  }

  List<BankTransaction> toList(List<Map<String, dynamic>> transactionMaps) {
    final List<BankTransaction> bankTransactions = [];

    for (Map<String, dynamic> transactionMap in transactionMaps) {
      final BankTransaction bankTransaction = BankTransaction(
        id: transactionMap[_id],
        name: transactionMap[_name],
        value: transactionMap[_value],
        account: transactionMap[_account],
        payDay: transactionMap[_payDay] == null
            ? null
            : DateTime.parse(transactionMap[_payDay]),
        alreadyPaid: Util.stringToBool(transactionMap[_alreadyPaid]),
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
    map[_payDay] = bankTransaction.payDay == null
        ? null
        : Util.formatToDate(bankTransaction.payDay!);
    map[_alreadyPaid] = bankTransaction.alreadyPaid.toString();
    return map;
  }
}
