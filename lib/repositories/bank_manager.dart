import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/bank_transaction_dao.dart';
import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BankManager {
  static Future<bool> createTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    Account account = accountsRepository.findByName(bankTransaction.account);
    account.movement(bankTransaction.value, bankTransaction.alreadyPaid);

    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransactionDAO.insert(batch, bankTransaction);
      AccountDAO.update(batch, account);
      await batch.commit(noResult: true);
    } on DatabaseException {
      account.movement(bankTransaction.value * -1, bankTransaction.alreadyPaid);

      return false;
    }

    bankTransactionsRepository.reloadAll();
    accountsRepository.updateAllGeneral(
        bankTransaction.value, bankTransaction.alreadyPaid);

    return true;
  }

  static Future<bool> createAccount(
    Account account,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      AccountDAO.insert(batch, account);
      await batch.commit(noResult: true);
    } on DatabaseException {
      return false;
    }

    accountsRepository.reloadAll();
    return true;
  }

  static void switchAlreadyPaid(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    Account account = accountsRepository.findByName(bankTransaction.account);
    account.payTransaction(bankTransaction.value, bankTransaction.alreadyPaid);

    DateTime? oldDate = bankTransaction.payDay;
    bankTransaction.changePaid();

    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransactionDAO.update(batch, bankTransaction);
      AccountDAO.update(batch, account);
      await batch.commit(noResult: true);
    } on DatabaseException catch (e) {
      account.payTransaction(
          bankTransaction.value * -1, bankTransaction.alreadyPaid);
      bankTransaction.changePaid();
      bankTransaction.payDay = oldDate;
      return;
    }

    bankTransactionsRepository.notify();
    accountsRepository.updateCurrent(
        bankTransaction.value, bankTransaction.alreadyPaid);
  }

  static Future<bool> deleteAccount(
    Account account,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      AccountDAO.delete(batch, account);
      BankTransactionDAO.deleteAllFromAccount(batch, account.name);
      await batch.commit(noResult: true);
    } on DatabaseException {
      return false;
    }

    bankTransactionsRepository.removeLocalByAccount(account.name);
    accountsRepository.removeLocal(account);
    return true;
  }

  static Future<bool> deleteTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    Account account = accountsRepository.findByName(bankTransaction.account);
    account.movement(bankTransaction.value * -1, bankTransaction.alreadyPaid);

    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransactionDAO.delete(batch, bankTransaction);
      AccountDAO.update(batch, account);
      await batch.commit(noResult: true);
    } on DatabaseException {
      account.movement(bankTransaction.value, bankTransaction.alreadyPaid);
      return false;
    }

    bankTransactionsRepository.removeLocal(bankTransaction);
    accountsRepository.updateAllGeneral(
        bankTransaction.value * -1, bankTransaction.alreadyPaid);
    return true;
  }
}
