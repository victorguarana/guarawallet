import 'package:flutter/material.dart';
import 'package:guarawallet/themes/theme_colors.dart';

ThemeData myTheme = ThemeData(
  primarySwatch: ThemeColors.primaryColor,
  primaryColor: ThemeColors.secondaryColor,
  secondaryHeaderColor: ThemeColors.primaryColor,
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
