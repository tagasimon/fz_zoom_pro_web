import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/features/authentication/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cUser = ref.watch(sessionNotifierProvider).loggedInUser;

    return Scaffold(
      appBar:
          const CompanyAppBarWidget(title: "PRODUCTS") as PreferredSizeWidget?,

      // AppBar(
      //   title: cUser?.companyId == null
      //       ? const Text("SETTINGS")
      //       : const CompanyAppBarWidget(),
      // ),
      body: Center(
        child: TextButton.icon(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text("Logout")),
      ),
    );
  }
}
