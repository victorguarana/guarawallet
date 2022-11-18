import 'package:flutter/material.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/screens/home_screen.dart';
import 'package:guarawallet/themes/my_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AccountsRepository(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet',
      theme: myTheme,
      home: const HomeScreen(),
    );
  }
}
