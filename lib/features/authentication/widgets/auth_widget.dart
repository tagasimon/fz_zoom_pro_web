import 'package:field_zoom_pro_web/core/presentation/widgets/navigation_rail_widget.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/auth_provider.dart';
import 'package:field_zoom_pro_web/features/authentication/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChangesProv = ref.watch(authStateChangesProvider);
    return authStateChangesProv.when(
      data: (user) {
        if (user?.uid == null) {
          return const SignInScreen();
        }
        return const NavigationRailWidget();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text('Error: $error')));
      },
    );
  }
}
