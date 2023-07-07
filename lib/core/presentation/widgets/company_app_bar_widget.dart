// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/custom_switch_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/request_full_screen_widget.dart';
import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:html' as html;

class CompanyAppBarWidget extends ConsumerWidget
    implements PreferredSizeWidget {
  final String? title;
  const CompanyAppBarWidget({super.key, this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(sessionNotifierProvider).loggedInUser;
    final companyInfoProv = ref.watch(companyInfoProvider);
    return AppBar(
      title: cUser?.companyId == null
          ? const Text("Home Screen")
          : companyInfoProv.when(
              data: (data) =>
                  title == null ? Text(data.companyName) : Text(title!),
              error: (e, s) => const Text("Errorr"),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      actions: [
        IconButton(
            onPressed: () => html.window.location.reload(),
            icon: const Icon(Icons.refresh)),
        const VerticalDivider(),
        const CustomSwitchWidget(),
        const VerticalDivider(),
        const RequestFullScreenWidget(),
        const VerticalDivider(),
        if (cUser != null)
          Center(
            child: Text(
              cUser.role,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
