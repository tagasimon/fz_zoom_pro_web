import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:field_zoom_pro_web/core/providers/app_theme_provider.dart';
import 'package:field_zoom_pro_web/features/authentication/presentation/widgets/auth_widget.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWidth = MediaQuery.sizeOf(context).width;
    return MaterialApp(
      title: 'Fz Pro',
      debugShowCheckedModeBanner: false,
      theme: ref.watch(appThemeProvider),
      home: deviceWidth < 600
          ? Scaffold(
              appBar: AppBar(
                title: const Text("Fz Pro"),
              ),
              body: const Center(
                child: Text(
                  "Consider using a device with a larger screen to view this app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : const AuthWidget(),
    );
  }
}
