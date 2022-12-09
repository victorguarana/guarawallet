import 'package:flutter/material.dart';
import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/account.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountsRepository extends ChangeNotifier {
  static const String tableSQL = '''CREATE TABLE $_tableName (
          $_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $_name TEXT NOT NULL,
          $_currentBalance REAL NOT NULL,
          $_expectedBalance REAL NOT NULL) ''';
  static const String _tableName = 'accountTable';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _currentBalance = 'current_balance';
  static const String _expectedBalance = 'expected_balance';

  List<Account> allAccounts = [];
  double generalCurrentBalance = 0;
  double generalExpectedBalance = 0;

  void insertDB(Batch batch, Account account) {
    batch.insert(_tableName, toMap(account));
  }

  void addLocal(Account account) {
    allAccounts.add(account);
    generalCurrentBalance += account.currentBalance;
    generalExpectedBalance += account.expectedBalance;

    notifyListeners();
  }

  void debitAccountDB(
      Batch batch, double value, String accountName, bool alreadyPaid) {
    if (alreadyPaid) {
      batch.rawUpdate(
          'UPDATE ${AccountsRepository._tableName} SET $_currentBalance = $_currentBalance + $value, $_expectedBalance = $_expectedBalance + $value WHERE $_name = "$accountName"');
    } else {
      batch.rawUpdate(
          'UPDATE ${AccountsRepository._tableName} SET $_expectedBalance = $_expectedBalance + $value WHERE $_name = "$accountName"');
    }
  }

  // TODO: Add id to model and DB and change accountName for accountID?
  // Or make account name primary key?
  void debitAccountLocal(double value, String accountName, bool alreadyPaid) {
    Account accounts =
        allAccounts.where((account) => account.name == accountName).first;

    accounts.expectedBalance += value;
    generalExpectedBalance += value;

    if (alreadyPaid) {
      accounts.currentBalance += value;
      generalCurrentBalance += value;
    }

    notifyListeners();
  }

  void deleteDB(Batch batch, Account account) {
    batch.delete(_tableName, where: '$_id = ${account.id}');
  }

  void removeLocal(Account account) {
    allAccounts.remove(account);
    generalCurrentBalance -= account.currentBalance;
    generalExpectedBalance -= account.expectedBalance;

    notifyListeners();
  }

  void payTransaction(
      Batch batch, double value, String accountName, bool alreadyPaid) {
    if (alreadyPaid) {
      value = value * -1;
    }
    batch.rawUpdate(
        'UPDATE ${AccountsRepository._tableName} SET $_currentBalance = $_currentBalance + $value WHERE $_name = "$accountName"');
  }

  void payTransactionLocal(double value, String accountName, bool alreadyPaid) {
    Account account =
        allAccounts.where((account) => account.name == accountName).first;

    if (alreadyPaid) {
      value = value * -1;
    }

    account.currentBalance += value;
    generalCurrentBalance += value;

    notifyListeners();
  }

  Future<List<Account>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  Future<void> loadAll() async {
    allAccounts = await findAll();

    generalCurrentBalance = 0;
    generalExpectedBalance = 0;
    for (Account account in allAccounts) {
      generalCurrentBalance += account.currentBalance;
      generalExpectedBalance += account.expectedBalance;
    }

    notifyListeners();
  }

  Future<List<Account>> find(int id) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tableName, where: '$_id = ?', whereArgs: [id]);
    return toList(result);
  }

  Future<void> deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tableName);
  }

  List<Account> toList(List<Map<String, dynamic>> accountMaps) {
    final List<Account> accounts = [];

    for (Map<String, dynamic> accountMap in accountMaps) {
      final Account account = Account(
        id: accountMap[_id],
        name: accountMap[_name],
        currentBalance: accountMap[_currentBalance],
        expectedBalance: accountMap[_expectedBalance],
      );
      accounts.add(account);
    }

    return accounts;
  }

  Map<String, dynamic> toMap(Account account) {
    final Map<String, dynamic> map = {};
    map[_id] = account.id;
    map[_name] = account.name;
    map[_currentBalance] = account.currentBalance;
    map[_expectedBalance] = account.expectedBalance;
    return map;
  }
}
