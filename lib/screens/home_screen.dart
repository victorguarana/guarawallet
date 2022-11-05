import 'package:flutter/material.dart';
import 'package:guarawallet/components/sections/accounts_section.dart';
import 'package:guarawallet/components/sections/overview_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          OverviewSection(),
          AccountsSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
