import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:provider/provider.dart';

class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      cardHeight: 300,
      cardContent: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Contas', style: Theme.of(context).textTheme.titleMedium),
            const Divider(color: Colors.grey, thickness: 1),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<AccountsRepository>(context, listen: false)
                    .loadAll(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : Consumer<AccountsRepository>(
                            builder: (context, accounts, child) {
                              if (accounts.allAccounts.isEmpty) {
                                return _NoAccounts();
                              } else {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemCount: accounts.allAccounts.length,
                                  itemBuilder: (context, index) {
                                    return AccountWidget(
                                        account: accounts.allAccounts[index]);
                                  },
                                );
                              }
                            },
                          ),
              ),
            ),
          ],
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
