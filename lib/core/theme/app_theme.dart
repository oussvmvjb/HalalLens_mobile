import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF176B52),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );
}
