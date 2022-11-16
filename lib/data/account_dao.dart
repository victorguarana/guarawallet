import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/data/database.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountDao {
  static const String tableSQL =
      'CREATE TABLE $_tablename ($_name TEXT PRIMARY KEY, $_currentBalance REAL, $_expectedBalance REAL) ';
  static const String _tablename = 'accountTable';

  static const String _name = 'name';
  static const String _currentBalance = 'current_balance';
  static const String _expectedBalance = 'expected_balance';

  save(AccountWidget accountWidget) async {
    final Database database = await getDataBase();

    var itemExists = await find(accountWidget.name);
    if (itemExists.isEmpty) {
      return await database.insert(_tablename, toMap(accountWidget));
    } else {
      return await database.update(_tablename, toMap(accountWidget),
          where: '$_name = ?', whereArgs: [accountWidget.name]);
    }
  }

  Future<List<AccountWidget>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    return toList(result);
  }

  Future<List<DropdownMenuItem>> findAllNames() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tablename, columns: [_name]);
    return toMenuItem(result);
  }

  Future<List<AccountWidget>> find(String name) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [name]);
    return toList(result);
  }

  List<DropdownMenuItem> toMenuItem(List<Map<String, dynamic>> accountMaps) {
    List<DropdownMenuItem> menuItems = [];
    for (Map<String, dynamic> accountMap in accountMaps) {
      final DropdownMenuItem accountItem = DropdownMenuItem(
        onTap: () {},
        value: accountMap[_name],
        child: Text(accountMap[_name]),
      );
      menuItems.add(accountItem);
    }
    return menuItems;
  }

  List<AccountWidget> toList(List<Map<String, dynamic>> accountMaps) {
    final List<AccountWidget> accountWidgets = [];

    for (Map<String, dynamic> accountMap in accountMaps) {
      final AccountWidget accountWidget = AccountWidget(
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
    map[_name] = accountWidget.name;
    map[_currentBalance] = accountWidget.currentBalance;
    map[_expectedBalance] = accountWidget.expectedBalance;
    return map;
  }

  deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tablename);
  }
}
