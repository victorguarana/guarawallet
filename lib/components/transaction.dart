import 'package:flutter/material.dart';

// TODO: Add Account and others fields to this widget
class Transaction extends StatelessWidget {
  final String name;
  final double value;
  const Transaction({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            Text('R\$ $value'),
          ],
        ));
  }
}
