// Timport 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class GlobalThemeData {
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 30, 135, 233),
    brightness: Brightness.light,
  );

  static final ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primaryFixed,
      foregroundColor: colorScheme.onPrimaryFixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          foregroundColor:
              WidgetStatePropertyAll(colorScheme.onPrimaryContainer),
          backgroundColor:
              WidgetStatePropertyAll(colorScheme.primaryContainer)),
    ),
  );
}
