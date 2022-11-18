import 'package:guarawallet/data/transaction_dao.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'guarawallet.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(TransactionDao.tableSQL);
      db.execute(AccountsRepository.tableSQL);
    },
    version: 1,
  );
}
