import 'package:flutter/material.dart';

class BasicCard extends StatelessWidget {
  final Widget cardContent;
  const BasicCard({Key? key, required this.cardContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: cardContent,
      ),
    );
  }
}
