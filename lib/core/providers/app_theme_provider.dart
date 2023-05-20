// generate app theme provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = StateNotifierProvider<AppThemeProvider, ThemeData>(
  (ref) => AppThemeProvider(),
);

class AppThemeProvider extends StateNotifier<ThemeData> {
  AppThemeProvider() : super(_darkTheme);

  static final _lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    // useMaterial3: true,
  );

  static final _darkTheme = ThemeData.dark();

  void toggleTheme() {
    state = state == _lightTheme ? _darkTheme : _lightTheme;
  }
}
