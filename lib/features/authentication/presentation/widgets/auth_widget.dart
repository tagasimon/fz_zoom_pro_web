import 'package:field_zoom_pro_web/core/presentation/widgets/navigation_rail_widget.dart';
import 'package:field_zoom_pro_web/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:field_zoom_pro_web/features/authentication/repositories/auth_repository.dart';
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
      error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
