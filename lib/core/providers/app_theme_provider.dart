// generate app theme provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = StateNotifierProvider<AppThemeProvider, ThemeData>(
  (ref) => AppThemeProvider(),
);

class AppThemeProvider extends StateNotifier<ThemeData> {
  AppThemeProvider() : super(_darkTheme);

  static final _lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      appBarTheme: const AppBarTheme(elevation: 0));

  static final _darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(elevation: 0),
  );

  void toggleTheme() {
    state = state == _lightTheme ? _darkTheme : _lightTheme;
  }
}
