import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final Widget cardContent;
  final String cardTitle;
  final double? cardHeight;
  const ListCard(
      {Key? key,
      required this.cardContent,
      this.cardHeight,
      required this.cardTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 400,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                cardTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(color: Colors.grey, thickness: 1),
              Expanded(child: cardContent)
            ],
          ),
        ),
      ),
    );
  }
}
