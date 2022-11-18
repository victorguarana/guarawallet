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

  void _refreshCache() async {
    List<Account> accounts = await findAll();
    allAccounts = accounts;
  }

  save(Account account) async {
    final Database database = await getDataBase();

    var itemExists = [];
    if (account.id != null) {
      itemExists = await find(account.id!);
    }

    if (itemExists.isEmpty) {
      await database.insert(_tableName, toMap(account));
    } else {
      await database.update(_tableName, toMap(account),
          where: '$_id = ?', whereArgs: [account.id]);
    }

    _refreshCache();
    notifyListeners();
  }

  // TODO: Move this logic to other class?
  debitAccount(Transaction txn, double value, String accountName) async {
    await txn.rawUpdate(
        'UPDATE ${AccountsRepository._tableName} SET $_currentBalance = $_currentBalance - $value, $_expectedBalance = $_expectedBalance - $value WHERE name = "$accountName"');
  }

  // Future<double> currentBalance() async {
  //   final Database database = await getDataBase();
  //   final List<Map<String, dynamic>> result = await database.rawQuery(
  //       'SELECT sum($_currentBalance) as $_currentBalance FROM $_tableName');
  //   double sum = result.single[_currentBalance];
  //   // double sum = 0;
  //   return sum;
  // }

  Future<List<Account>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  Future<List<Account>> find(int id) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tableName, where: '$_id = ?', whereArgs: [id]);
    return toList(result);
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

  deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tableName);
  }
}
