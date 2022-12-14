import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/bank_transaction_widget.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_manager.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/bank_transaction_form_screen.dart';
import 'package:guarawallet/themes/theme_colors.dart';
import 'package:provider/provider.dart';

class BankTransactionsListScreen extends StatefulWidget {
  const BankTransactionsListScreen({super.key});

  @override
  State<BankTransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<BankTransactionsListScreen> {
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  void _showResult(bool result, String accountName) {
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          content: Text('Conta \'$accountName\' foi deletada!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar conta \'$accountName\'.'),
          backgroundColor: ThemeColors.scaffoldMessengerColor,
        ),
      );
    }
  }

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
                      const BankTransactionFormScreen(isDebit: true),
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
                      const BankTransactionFormScreen(isDebit: false),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatefulWidget {
  // const _AccountItem({super.key});
  final BankTransaction bankTransaction;
  final BankTransactionsRepository bankTransactionsRepository;
  final AccountsRepository accountsRepository;

  const _AccountItem(
      {required this.bankTransaction,
      required this.bankTransactionsRepository,
      required this.accountsRepository});
  @override
  State<_AccountItem> createState() => __AccountItemState();
}

class __AccountItemState extends State<_AccountItem> {
  void _showResult(bool result, String accountName) {
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          content: Text('Conta \'$accountName\' foi deletada!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar conta \'$accountName\'.'),
          backgroundColor: ThemeColors.scaffoldMessengerColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        alignment: Alignment.centerLeft,
        color:
            widget.bankTransaction.alreadyPaid ? Colors.orange : Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: widget.bankTransaction.alreadyPaid
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
          BankManager.switchAlreadyPaid(widget.bankTransaction,
              widget.bankTransactionsRepository, widget.accountsRepository);
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
        return false;
      },
      onDismissed: (direction) async {
        if (direction != DismissDirection.endToStart) {
          return;
        }
        await BankManager.deleteTransaction(widget.bankTransaction,
            widget.bankTransactionsRepository, widget.accountsRepository);
      },
      child: Column(children: [
        const ListCardDivider(),
        BankTransactionWidget(transaction: widget.bankTransaction),
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
