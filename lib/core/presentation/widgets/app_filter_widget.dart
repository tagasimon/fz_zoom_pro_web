import 'package:field_zoom_pro_web/core/presentation/widgets/region_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppFilterWidget extends ConsumerWidget {
  final bool showRegionFilter;
  final bool showRouteFilter;
  final bool showAssociateFilter;
  final bool showStartDateFilter;
  final bool showEndDateFilter;
  const AppFilterWidget({
    super.key,
    this.showRegionFilter = false,
    this.showRouteFilter = false,
    this.showAssociateFilter = false,
    this.showEndDateFilter = false,
    this.showStartDateFilter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (showRegionFilter) const RegionFilterWidget(),
                  const VerticalDivider(),
                  // if (showAgentFilter) const AgentFilterWidget(),
                  // const VerticalDivider(),
                  // if (showRouteFilter) const RouteFilterWidget(),
                  // const VerticalDivider(),
                  // if (showAssociateFilter) const AssociateFilterWidget(),
                  // const VerticalDivider(),
                  // if (stockTypeFilter) const StockTypeFilterWidget(),
                  // const VerticalDivider(),
                  // if (showStartDateFilter)
                  //   const DateFilterWidget(isStartDate: true),
                  // const VerticalDivider(),
                  // if (showStartDateFilter)
                  //   const DateFilterWidget(isStartDate: false),
                  // const VerticalDivider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
