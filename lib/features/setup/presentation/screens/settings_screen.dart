import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(filterNotifierProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: cUser?.companyId == null
            ? const Text("SETTINGS")
            : const CompanyTitleWidget(),
      ),
      body: Center(
        child: TextButton.icon(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout")),
      ),
    );
  }
}