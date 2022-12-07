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
      bankTransaction.changePaid();

      bankTransactionsRepository.paid(
          batch, bankTransaction, accountsRepository);
      accountsRepository.payTransaction(batch, bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      bankTransactionsRepository.notify();
      accountsRepository.loadAll();
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

      bankTransactionsRepository.save(batch, bankTransaction);
      accountsRepository.debitAccount(batch, bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      // print(result);
      bankTransactionsRepository.loadAll();
      accountsRepository.loadAll();
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

      accountsRepository.save(batch, account);
      await batch.commit(noResult: true);

      accountsRepository.notify();
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

      accountsRepository.delete(batch, account);
      bankTransactionsRepository.deleteAllFromAccount(batch, account.name);
      await batch.commit(noResult: true);

      bankTransactionsRepository.loadAll();
      accountsRepository.loadAll();
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

      bankTransactionsRepository.delete(batch, bankTransaction);
      accountsRepository.debitAccount(batch, bankTransaction.value * -1,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      bankTransactionsRepository.notify();
      accountsRepository.loadAll();
    } on DatabaseException catch (e) {
      print('Erro no sqflite');
    }
  }
}
