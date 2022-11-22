import 'package:flutter/material.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/repositories/bank_transctions_repository.dart';
import 'package:provider/provider.dart';

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      cardTitle: 'Transações',
      cardHeight: 230,
      cardContent: FutureBuilder(
        future: Provider.of<BankTransactionsRepository>(context, listen: false)
            .loadAll(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Consumer<BankTransactionsRepository>(
                    builder: (context, accounts, child) {
                      if (accounts.allTransactions.isEmpty) {
                        return const _NoTransactions();
                      } else {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: accounts.allTransactions.length,
                          itemBuilder: (context, index) {
                            return TransactionWidget(
                                transaction: accounts.allTransactions[index]);
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
  const _NoTransactions({super.key});

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
