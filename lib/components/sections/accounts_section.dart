import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:provider/provider.dart';

class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      cardTitle: 'Contas',
      cardHeight: 300,
      cardContent: FutureBuilder(
        future:
            Provider.of<AccountsRepository>(context, listen: false).loadAll(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<AccountsRepository>(
                builder: (context, accounts, child) {
                  if (accounts.allAccounts.isEmpty) {
                    return const _NoAccounts();
                  } else {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: accounts.allAccounts.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          AccountWidget(account: accounts.allAccounts[index]),
                          const ListCardDivider(),
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

class _NoAccounts extends StatelessWidget {
  const _NoAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.no_accounts,
            size: 68,
          ),
          Text(
            'Não existem contas cadastradas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
