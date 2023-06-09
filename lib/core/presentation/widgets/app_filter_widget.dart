// ignore: avoid_web_libraries_in_flutter

import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:field_zoom_pro_web/core/presentation/widgets/date_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/region_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/selected_user_filter_widget.dart';

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
    final region = ref.watch(quickfilterNotifierProvider).region;
    final selectedUserId =
        ref.watch(quickfilterNotifierProvider).selectedUserId;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showStartDateFilter) const DateFilterWidget(isStartDate: true),
          if (showStartDateFilter) const VerticalDivider(),
          if (showStartDateFilter) const DateFilterWidget(isStartDate: false),
          if (showStartDateFilter) const VerticalDivider(),
          if (showRegionFilter) const RegionFilterWidget(),
          if (showRegionFilter) const VerticalDivider(),
          // TODO Watch this Filter
          if (showSelectedUserFilter) const SelectedUserFilterWidget(),
          if (showSelectedUserFilter) const VerticalDivider(),
          if (region != null || selectedUserId != null)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              onPressed: () => ref
                  .read(quickfilterNotifierProvider.notifier)
                  .resetQuickFilter(),
              child: const Text("reset"),
            )
        ],
      ),
    );
  }
}
