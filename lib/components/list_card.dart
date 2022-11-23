import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final Widget cardContent;
  final String cardTitle;
  final double? cardHeight;

  // Need to pass as a fuction because it needs to create a new MaterialPageRoute every time
  final MaterialPageRoute<dynamic> Function()? listScreenRouter;

  const ListCard(
      {Key? key,
      required this.cardContent,
      required this.cardTitle,
      this.listScreenRouter,
      this.cardHeight})
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  _ListScreenButton(listScreenRouter),
                ],
              ),
              const ListCardDivider(),
              Expanded(child: cardContent)
            ],
          ),
        ),
      ),
    );
  }
}

class ListCardDivider extends StatelessWidget {
  const ListCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.grey, thickness: 1);
  }
}

class _ListScreenButton extends StatelessWidget {
  final MaterialPageRoute<dynamic> Function()? listRouter;

  const _ListScreenButton(this.listRouter);

  @override
  Widget build(BuildContext context) {
    return listRouter != null
        ? IconButton(
            onPressed: () => Navigator.push(context, listRouter!()),
            icon: const Icon(Icons.open_in_new),
          )
        : const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.open_in_new,
              color: Colors.grey,
            ),
          );
  }
}
