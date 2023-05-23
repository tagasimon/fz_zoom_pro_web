import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
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
            : const CompanyTitleWidget(),
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
