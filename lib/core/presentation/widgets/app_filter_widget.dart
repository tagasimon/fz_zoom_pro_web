// ignore: avoid_web_libraries_in_flutter

import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/date_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/region_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/selected_user_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppFilterWidget extends ConsumerWidget {
  final bool showRegionFilter;
  final bool showRouteFilter;
  final bool showSelectedUserFilter;
  final bool showStartDateFilter;
  final bool showEndDateFilter;
  const AppFilterWidget({
    super.key,
    this.showRegionFilter = false,
    this.showRouteFilter = false,
    this.showSelectedUserFilter = false,
    this.showEndDateFilter = false,
    this.showStartDateFilter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(filterNotifierProvider).region;
    final selectedUserId = ref.watch(filterNotifierProvider).selectedUserId;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const VerticalDivider(),
          if (showRegionFilter) const RegionFilterWidget(),
          if (showRegionFilter) const VerticalDivider(),
          if (showSelectedUserFilter) const SelectedUserFilterWidget(),
          if (showSelectedUserFilter) const VerticalDivider(),
          if (showStartDateFilter) const DateFilterWidget(isStartDate: true),
          if (showStartDateFilter) const VerticalDivider(),
          if (showStartDateFilter) const DateFilterWidget(isStartDate: false),
          if (showStartDateFilter) const VerticalDivider(),
          region == null || selectedUserId == null
              ? const SizedBox.shrink()
              : TextButton.icon(
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.redAccent),
                  onPressed: () =>
                      ref.read(filterNotifierProvider.notifier).resetFilter(),
                  label: const Text("Reset"),
                  icon: const Icon(Icons.refresh),
                )
        ],
      ),
    );
  }
}
