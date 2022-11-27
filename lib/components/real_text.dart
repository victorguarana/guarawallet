import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final bool changeColor;

  const RealText(
      {super.key, required this.value, this.style, this.changeColor = false});

  TextStyle? _setStyle() {
    if (!changeColor) {
      return style;
    }

    if (value.isNegative) {
      if (style != null) {
        return style!.copyWith(color: Colors.red[300]);
      } else {
        return (TextStyle(color: Colors.red[300]));
      }
    }
    return style;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        NumberFormat.simpleCurrency(locale: 'pt-BR', decimalDigits: 2)
            .format(value),
        style: _setStyle());
  }
}
