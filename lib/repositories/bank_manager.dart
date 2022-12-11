import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/bank_transaction_dao.dart';
import 'package:guarawallet/data/database.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:sqflite/sqlite_api.dart';

class BankManager {
  static void switchAlreadyPaid(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransaction bankTransactionClone = bankTransaction.clone();
      bankTransactionClone.changePaid();

      BankTransactionDAO.switchAlreadyPaid(batch, bankTransactionClone);
      AccountDAO.payTransaction(batch, bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      accountsRepository.payTransactionLocal(bankTransaction.value,
          bankTransaction.account, bankTransaction.alreadyPaid);
      bankTransactionsRepository.switchAlreadyPaidLocal(bankTransaction);
    } on DatabaseException {
      return;
    }
  }

  static Future<bool> createTransaction(
    BankTransaction bankTransaction,
    Account account,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();
      account.movement(bankTransaction.value, bankTransaction.alreadyPaid);

      BankTransactionDAO.insert(batch, bankTransaction);
      AccountDAO.update(batch, account);
      await batch.commit(noResult: true);

      bankTransactionsRepository.addLocal(bankTransaction);
      accountsRepository.updateGeneral(
          bankTransaction.value, bankTransaction.alreadyPaid);

      return true;
    } on DatabaseException {
      account.movement(bankTransaction.value * -1, bankTransaction.alreadyPaid);

      return false;
    }
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

      accountsRepository.addLocal(account);
      return true;
    } on DatabaseException {
      return false;
    }
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

      bankTransactionsRepository.deleteAllFromAccountLocal(account.name);
      accountsRepository.removeLocal(account);
      return true;
    } on DatabaseException {
      return false;
    }
  }

  static Future<bool> deleteTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    try {
      final Database database = await getDataBase();
      Batch batch = database.batch();

      BankTransactionDAO.delete(batch, bankTransaction);
      AccountDAO.debitAccount(batch, bankTransaction.value * -1,
          bankTransaction.account, bankTransaction.alreadyPaid);
      await batch.commit(noResult: true);

      bankTransactionsRepository.removeLocal(bankTransaction);
      accountsRepository.updateGeneral(
          bankTransaction.value * -1, bankTransaction.alreadyPaid);
      return true;
    } on DatabaseException {
      return false;
    }
  }
}
