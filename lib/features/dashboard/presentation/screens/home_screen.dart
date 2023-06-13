import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/kpi_widget.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppFilterWidget(
            showRegionFilter: true,
            showStartDateFilter: true,
            showEndDateFilter: true,
          ),
          Divider(),
          SizedBox(height: 20),
          Wrap(
            children: [
              KpiWidget(),
              KpiWidget(),
              KpiWidget(),
              KpiWidget(),
              KpiWidget(),
              KpiWidget(),
            ],
          )
        ],
      ),
    );
  }
}
