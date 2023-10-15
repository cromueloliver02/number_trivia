import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade800),
    primaryColor: Colors.green.shade800,
    useMaterial3: true,
  );
}
