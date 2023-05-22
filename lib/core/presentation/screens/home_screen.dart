import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(filterNotifierProvider).user;
    return Scaffold(
      appBar: AppBar(
        title: cUser?.companyId == null
            ? const Text("Home Screen")
            : Consumer(
                builder: (context, ref, _) {
                  final companyInfoProv = ref.watch(companyInfoProvider);
                  return companyInfoProv.when(
                      data: (data) => Text(data.companyName),
                      error: (error, stackTrace) => const Text("Error"),
                      loading: () => const Text("Loading ..."));
                },
              ),
      ),
      body: const Column(
        children: [
          AppFilterWidget(
            showRegionFilter: true,
            showStartDateFilter: true,
            showEndDateFilter: true,
          ),
          Text("Home Screen")
        ],
      ),
    );
  }
}
