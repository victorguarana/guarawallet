import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealText extends StatelessWidget {
  final double value;
  final TextStyle? style;

  const RealText({super.key, required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      NumberFormat.simpleCurrency(locale: 'pt-BR', decimalDigits: 2)
          .format(value),
      style: style,
    );
  }
}
