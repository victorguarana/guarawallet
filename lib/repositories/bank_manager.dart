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
    final Database database = await getDataBase();
    Batch batch = database.batch();
    bankTransaction.changePaid();

    bankTransactionsRepository.paid(batch, bankTransaction, accountsRepository);
    accountsRepository.payTransaction(batch, bankTransaction.value,
        bankTransaction.account, bankTransaction.alreadyPaid);
    batch.commit(noResult: true);

    bankTransactionsRepository.notify();
    accountsRepository.loadAll();
  }

  void createTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    final Database database = await getDataBase();
    Batch batch = database.batch();

    bankTransactionsRepository.save(batch, bankTransaction);
    accountsRepository.debitAccount(batch, bankTransaction.value,
        bankTransaction.account, bankTransaction.alreadyPaid);
    batch.commit(noResult: true);

    bankTransactionsRepository.notify();
    accountsRepository.loadAll();
  }

  void createAccount(
    Account account,
    AccountsRepository accountsRepository,
  ) async {
    final Database database = await getDataBase();
    Batch batch = database.batch();

    accountsRepository.save(batch, account);
    batch.commit(noResult: true);

    accountsRepository.notify();
  }

  void deleteAccount(
    Account account,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    final Database database = await getDataBase();
    Batch batch = database.batch();

    accountsRepository.delete(batch, account);
    bankTransactionsRepository.deleteAllFromAccount(batch, account.name);
    batch.commit(noResult: true);

    bankTransactionsRepository.loadAll();
    accountsRepository.loadAll();
  }

  void deleteTransaction(
    BankTransaction bankTransaction,
    BankTransactionsRepository bankTransactionsRepository,
    AccountsRepository accountsRepository,
  ) async {
    final Database database = await getDataBase();
    Batch batch = database.batch();

    bankTransactionsRepository.delete(batch, bankTransaction);
    accountsRepository.debitAccount(batch, bankTransaction.value * -1,
        bankTransaction.account, bankTransaction.alreadyPaid);
    batch.commit(noResult: true);

    bankTransactionsRepository.notify();
    accountsRepository.loadAll();
  }
}
