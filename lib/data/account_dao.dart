import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/data/database.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountDao {
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

  save(AccountWidget accountWidget) async {
    final Database database = await getDataBase();

    if (accountWidget.id == null) {
      return await database.insert(_tableName, toMap(accountWidget));
    }

    var itemExists = await find(accountWidget.id!);
    if (itemExists.isEmpty) {
      return await database.insert(_tableName, toMap(accountWidget));
    } else {
      return await database.update(_tableName, toMap(accountWidget),
          where: '$_id = ?', whereArgs: [accountWidget.id]);
    }
  }

  // TODO: Move this logic to other class?
  debitAccount(Transaction txn, double value, String accountName) async {
    await txn.rawUpdate(
        'UPDATE ${AccountDao._tableName} SET $_currentBalance = $_currentBalance - $value, $_expectedBalance = $_expectedBalance - $value WHERE name = "$accountName"');
  }

  // Future<double> currentBalance() async {
  //   final Database database = await getDataBase();
  //   final List<Map<String, dynamic>> result = await database.rawQuery(
  //       'SELECT sum($_currentBalance) as $_currentBalance FROM $_tableName');
  //   double sum = result.single[_currentBalance];
  //   // double sum = 0;
  //   return sum;
  // }

  Future<List<AccountWidget>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  Future<List<DropdownMenuItem>> findAllNames() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tableName, columns: [_id, _name]);
    return toMenuItem(result);
  }

  Future<List<AccountWidget>> find(int id) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tableName, where: '$_id = ?', whereArgs: [id]);
    return toList(result);
  }

// TODO: This method should be here?
  List<DropdownMenuItem> toMenuItem(List<Map<String, dynamic>> accountMaps) {
    List<DropdownMenuItem> menuItems = [];
    for (Map<String, dynamic> accountMap in accountMaps) {
      final DropdownMenuItem accountItem = DropdownMenuItem(
        value: accountMap[_name],
        child: Center(child: Text(accountMap[_name])),
      );
      menuItems.add(accountItem);
    }
    return menuItems;
  }

  List<AccountWidget> toList(List<Map<String, dynamic>> accountMaps) {
    final List<AccountWidget> accountWidgets = [];

    for (Map<String, dynamic> accountMap in accountMaps) {
      final AccountWidget accountWidget = AccountWidget(
        id: accountMap[_id],
        name: accountMap[_name],
        currentBalance: accountMap[_currentBalance],
        expectedBalance: accountMap[_expectedBalance],
      );
      accountWidgets.add(accountWidget);
    }

    return accountWidgets;
  }

  Map<String, dynamic> toMap(AccountWidget accountWidget) {
    final Map<String, dynamic> map = {};
    map[_id] = accountWidget.id;
    map[_name] = accountWidget.name;
    map[_currentBalance] = accountWidget.currentBalance;
    map[_expectedBalance] = accountWidget.expectedBalance;
    return map;
  }

  deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tableName);
  }
}
