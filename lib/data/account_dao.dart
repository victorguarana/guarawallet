import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/account.dart';
import 'package:sqflite/sqflite.dart';

class AccountDAO {
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

  static void insert(Batch batch, Account account) {
    batch.insert(_tableName, toMap(account));
  }

  static void update(Batch batch, Account account) {
    batch.update(_tableName, toMap(account),
        where: '$_id = ?', whereArgs: [account.id]);
  }

  static Future<List<Account>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  static void debitAccount(
      Batch batch, double value, String accountName, bool alreadyPaid) {
    // TODO: move this logic to model
    if (alreadyPaid) {
      batch.rawUpdate(
          'UPDATE $_tableName SET $_currentBalance = $_currentBalance + $value, $_expectedBalance = $_expectedBalance + $value WHERE $_name = "$accountName"');
    } else {
      batch.rawUpdate(
          'UPDATE $_tableName SET $_expectedBalance = $_expectedBalance + $value WHERE $_name = "$accountName"');
    }
  }

  static void delete(Batch batch, Account account) {
    batch.delete(_tableName, where: '$_id = ${account.id}');
  }

  static void payTransaction(
      Batch batch, double value, String accountName, bool alreadyPaid) {
    // TODO: move this logic to model
    if (alreadyPaid) {
      value = value * -1;
    }
    batch.rawUpdate(
        'UPDATE $_tableName SET $_currentBalance = $_currentBalance + $value WHERE $_name = "$accountName"');
  }

  // TODO: Remove this after build
  static Future<void> deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tableName);
  }

  static List<Account> toList(List<Map<String, dynamic>> accountMaps) {
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

  static Map<String, dynamic> toMap(Account account) {
    final Map<String, dynamic> map = {};
    map[_id] = account.id;
    map[_name] = account.name;
    map[_currentBalance] = account.currentBalance;
    map[_expectedBalance] = account.expectedBalance;
    return map;
  }
}
