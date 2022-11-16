import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/transaction_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'guarawallet.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TransactionDao.tableSQL);
      db.execute(AccountDao.tableSQL);
    },
    version: 1,
  );
}
