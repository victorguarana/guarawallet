import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/transaction_form_screen.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // TODO: Check if exists a better way to get accounts repository outside this class
  // (Maybe inside other repositories?)
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  @override
  Widget build(BuildContext context) {
    bankTransactionsRepository = context.watch<BankTransactionsRepository>();
    accountsRepository = context.watch<AccountsRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Transações'),
      ),
      body: Consumer<BankTransactionsRepository>(
        builder: (context, transactions, child) {
          if (transactions.allTransactions.isEmpty) {
            return const _NoTransactions();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              itemCount: transactions.allTransactions.length,
              itemBuilder: (context, index) {
                BankTransaction bankTransaction =
                    transactions.allTransactions[index];
                return _AccountItem(
                  bankTransaction: bankTransaction,
                  bankTransactionsRepository: bankTransactionsRepository,
                  accountsRepository: accountsRepository,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        children: [
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Adicionar saída',
            child: Icon(Icons.swap_horiz, color: Colors.red[400]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TransactionFormScreen(isDebit: true),
                ),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Adicionar entrada',
            child: Icon(Icons.swap_horiz, color: Colors.green[400]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TransactionFormScreen(isDebit: false),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final BankTransaction bankTransaction;
  final BankTransactionsRepository bankTransactionsRepository;
  final AccountsRepository accountsRepository;

  const _AccountItem(
      {required this.bankTransaction,
      required this.bankTransactionsRepository,
      required this.accountsRepository});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        color: bankTransaction.alreadyPaid ? Colors.orange : Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: bankTransaction.alreadyPaid
              ? const Icon(Icons.money_off, color: Colors.white)
              : const Icon(Icons.attach_money, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          bankTransactionsRepository.paid(bankTransaction, accountsRepository,
              !bankTransaction.alreadyPaid);
          return false;
        }

        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: ((context) {
              return const _AlertDialog();
            }),
          );
        }
      },
      onDismissed: (direction) {
        if (direction != DismissDirection.endToStart) {
          return;
        }
        bankTransactionsRepository.delete(bankTransaction, accountsRepository);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            content:
                Text('Transação \'${bankTransaction.name}\' foi deletada!'),
          ),
        );
      },
      child: Column(children: [
        const ListCardDivider(),
        TransactionWidget(transaction: bankTransaction),
        const ListCardDivider()
      ]),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        'Deseja deletar esta transação?',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text(
            'Confirmar',
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class _NoTransactions extends StatelessWidget {
  const _NoTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.swap_horiz,
            size: 68,
          ),
          Text(
            'Não existem transações.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
