import 'package:flutter/material.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/bank_transaction_widget.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/bank_transactions_list_screen.dart';
import 'package:provider/provider.dart';

class BankTransactionsSection extends StatelessWidget {
  static const int _listSize = 5;
  const BankTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      cardTitle: 'Transações',
      cardHeight: 305,
      listScreenRouter: () => MaterialPageRoute(
          builder: (context) => const BankTransactionsListScreen()),
      cardContent: FutureBuilder(
        future: Provider.of<BankTransactionsRepository>(context, listen: false)
            .reloadAll(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<BankTransactionsRepository>(
                builder: (context, transactions, child) {
                  if (transactions.allTransactions.isEmpty) {
                    return const _NoTransactions();
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: transactions.allTransactions.length > _listSize
                          ? _listSize
                          : transactions.allTransactions.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          BankTransactionWidget(
                              transaction: transactions.allTransactions[index]),
                          const ListCardDivider()
                        ]);
                      },
                    );
                  }
                },
              ),
      ),
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
