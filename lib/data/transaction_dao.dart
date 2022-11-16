import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/database.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionDao {
  // TODO: Check why tables are not created with onCreate param (try to update version?)
  static const String tableSQL =
      'CREATE TABLE $_tablename ($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT NOT NULL, $_value REAL NOT NULL, $_account TEXT NOT NULL) ';
  static const String _tablename = 'transactionTable';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _value = 'value';
  static const String _account = 'account';

  save(TransactionWidget transactionWidget) async {
    final Database database = await getDataBase();

    // TODO: Move this logic to other class?
    if (transactionWidget.id == null) {
      return await database.transaction((txn) async {
        await txn.insert(_tablename, toMap(transactionWidget));
        await AccountDao().debitAccount(
            txn, transactionWidget.value, transactionWidget.account);
      });
    }

    var itemExists = await find(transactionWidget.id!);
    if (itemExists.isEmpty) {
      return await database.insert(_tablename, toMap(transactionWidget));
    } else {
      return await database.update(_tablename, toMap(transactionWidget),
          where: '$_name = ?', whereArgs: [transactionWidget.name]);
    }
  }

  Future<List<TransactionWidget>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    return toList(result);
  }

  Future<List<TransactionWidget>> find(int id) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result =
        await database.query(_tablename, where: '$_id = ?', whereArgs: [id]);
    return toList(result);
  }

  List<TransactionWidget> toList(List<Map<String, dynamic>> transactionMaps) {
    final List<TransactionWidget> transactionWidgets = [];

    for (Map<String, dynamic> transactionMap in transactionMaps) {
      final TransactionWidget transactionWidget = TransactionWidget(
        id: transactionMap[_id],
        name: transactionMap[_name],
        value: transactionMap[_value],
        account: transactionMap[_account],
      );
      transactionWidgets.add(transactionWidget);
    }

    return transactionWidgets;
  }

  Map<String, dynamic> toMap(TransactionWidget transactionWidget) {
    final Map<String, dynamic> map = {};
    map[_id] = transactionWidget.id;
    map[_name] = transactionWidget.name;
    map[_value] = transactionWidget.value;
    map[_account] = transactionWidget.account;
    return map;
  }

  deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tablename);
  }
}
