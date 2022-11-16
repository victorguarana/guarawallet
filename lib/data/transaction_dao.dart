import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/data/database.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionDao {
  static const String tableSQL =
      'CREATE TABLE $_tablename ($_name TEXT, $_value REAL, $_account TEXT) ';
  static const String _tablename = 'transactionTable';

  static const String _name = 'name';
  static const String _value = 'value';
  static const String _account = 'account';

  save(TransactionWidget transactionWidget) async {
    final Database database = await getDataBase();

    var itemExists = await find(transactionWidget.name);
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

  Future<List<TransactionWidget>> find(String name) async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [name]);
    return toList(result);
  }

  List<TransactionWidget> toList(List<Map<String, dynamic>> transactionMaps) {
    final List<TransactionWidget> transactionWidgets = [];

    for (Map<String, dynamic> transactionMap in transactionMaps) {
      final TransactionWidget transactionWidget = TransactionWidget(
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
