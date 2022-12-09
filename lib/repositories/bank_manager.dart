import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BankManager {
  void switchAlreadyPaid(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransaction bankTransactionClone = bankTransaction.clone();
      bankTransactionClone.changePaid();

      bankTransactionsRepository.switchAlreadyPaid(batch, bankTransactionClone);
      accountsRepository.payTransaction(batch, bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      accountsRepository.payTransactionLocal(bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      bankTransactionsRepository.switchAlreadyPaidLocal(bankTransaction);
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }

  void createTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      bankTransactionsRepository.insertDB(batch, bankTransaction);
      accountsRepository.debitAccountDB(batch, bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      bankTransactionsRepository.addLocal(bankTransaction);
      accountsRepository.debitAccountLocal(bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }

  void createAccount(
    Account account,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      accountsRepository.insertDB(batch, account);
      await batch.commit(noResult: true);

      accountsRepository.addLocal(account);
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }

  void deleteAccount(
    Account account,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      accountsRepository.deleteDB(batch, account);
      bankTransactionsRepository.deleteAllFromAccountDB(batch, account.name);
      await batch.commit(noResult: true);

      bankTransactionsRepository.deleteAllFromAccountLocal(account.name);
      accountsRepository.removeLocal(account);
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }

  void deleteTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      bankTransactionsRepository.deleteDB(batch, bankTransaction);
      accountsRepository.debitAccountDB(batch, bankTransaction.value * -1,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      bankTransactionsRepository.removeLocal(bankTransaction);
      accountsRepository.debitAccountLocal(bankTransaction.value * -1,
          bankTransaction.account, bankTransaction.alreadyPaid);
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }
}
