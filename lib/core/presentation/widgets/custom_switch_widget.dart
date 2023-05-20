// custom switch widget with light and dark mode

import 'package:field_zoom_pro_web/core/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSwitchWidget extends ConsumerWidget {
  const CustomSwitchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Switch(
      value: ref.watch(appThemeProvider).brightness == Brightness.dark,
      onChanged: (_) => ref.read(appThemeProvider.notifier).toggleTheme(),
      activeColor: Theme.of(context).colorScheme.primary,
      activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
      inactiveThumbColor: Theme.of(context).colorScheme.secondary,
      inactiveTrackColor: Theme.of(context).colorScheme.secondaryContainer,
      thumbIcon: MaterialStateProperty.all(
        Icon(
          Icons.nightlight_round,
          color: ref.watch(appThemeProvider).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
