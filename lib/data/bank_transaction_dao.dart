import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/utils/util.dart';
import 'package:sqflite/sqflite.dart';

class BankTransactionDAO {
  static const String tableSQL = '''CREATE TABLE $_tableName 
        ($_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_name TEXT NOT NULL,
        $_value REAL NOT NULL,
        $_account TEXT NOT NULL,
        $_payDay DATE,
        $_alreadyPaid BOOLEAN NOT NULL)''';
  static const String _tableName = 'transactionTable';

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _value = 'value';
  static const String _account = 'account';
  static const String _payDay = 'pay_day';
  static const String _alreadyPaid = 'already_paid';

  static void insert(Batch batch, BankTransaction bankTransaction) {
    batch.insert(_tableName, toMap(bankTransaction));
  }

  static void update(Batch batch, BankTransaction bankTransaction) {
    batch.update(_tableName, toMap(bankTransaction),
        where: '$_id = ?', whereArgs: [bankTransaction.id]);
  }

  static void delete(Batch batch, BankTransaction bankTransaction) {
    batch.delete(_tableName, where: '$_id = ${bankTransaction.id}');
  }

  static void deleteAllFromAccount(Batch batch, String accountName) {
    batch.delete(_tableName, where: '$_account = \'$accountName\'');
  }

  static Future<List<BankTransaction>> findAll() async {
    final Database database = await getDataBase();
    final List<Map<String, dynamic>> result = await database.query(_tableName,
        orderBy: '$_payDay DESC, $_id NULLS FIRST');
    // TODO: Put this back when pagination is ready
    // where:
    //     '(strftime(\'%m\', $_payDay) = strftime(\'%m\', \'now\', \'localtime\') AND strftime(\'%Y\', $_payDay) = strftime(\'%Y\', \'now\', \'localtime\')) OR $_payDay IS NULL');
    return toList(result);
  }

  static Future<void> deleteAll() async {
    final Database database = await getDataBase();
    await database.delete(_tableName);
  }

  static List<BankTransaction> toList(
      List<Map<String, dynamic>> transactionMaps) {
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

  static Map<String, dynamic> toMap(BankTransaction bankTransaction) {
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
