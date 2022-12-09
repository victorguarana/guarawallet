import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'guarawallet.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(BankTransactionsRepository.tableSQL);
      db.execute(AccountsRepository.tableSQL);
    },
    // TODO: Remove onUpgrade and onDowngrade before build apk
    onUpgrade: (db, oldVersion, newVersion) {
      _resetDB(db);
    },
    onDowngrade: (db, oldVersion, newVersion) {
      _resetDB(db);
    },
    version: 1,
  );
}

void _resetDB(Database db) {
  db.execute('DROP TABLE accountTable');
  db.execute('DROP TABLE transactionTable');
  db.execute(BankTransactionsRepository.tableSQL);
  db.execute(AccountsRepository.tableSQL);
}
