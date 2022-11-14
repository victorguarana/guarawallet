import 'package:flutter/material.dart';

class BasicCard extends StatelessWidget {
  final Widget cardContent;
  final double? cardHeight;
  const BasicCard({Key? key, required this.cardContent, this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        width: 400,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: cardContent,
      ),
    );
  }
}
