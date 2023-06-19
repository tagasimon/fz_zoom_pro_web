import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_map_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_summary_table.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/top_sales_person_table.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/visit_adherence_map_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/visits_summary_table_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(filterNotifierProvider).loggedInuser;
    final dasboardProv = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: cUser?.companyId == null
            ? const Text("Home Screen")
            : const CompanyTitleWidget(),
      ),
      body: dasboardProv.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: NothingFoundAnimation());
          }
          List<OrderModel> ordersList = data[0] as List<OrderModel>;
          List<VisitModel> visitsList = data[1] as List<VisitModel>;

          final regionId = ref.watch(filterNotifierProvider).region;
          final userId = ref.watch(filterNotifierProvider).selectedUserId;
          if (regionId != null) {
            ordersList = ordersList
                .where((element) => element.regionId == regionId)
                .toList();
            visitsList = visitsList
                .where((element) => element.regionId == regionId)
                .toList();
          }
          if (userId != null) {
            ordersList = ordersList
                .where((element) => element.userId == userId)
                .toList();
            visitsList = visitsList
                .where((element) => element.userId == userId)
                .toList();
          }
          if (regionId != null && userId != null) {
            ordersList = ordersList
                .where((element) =>
                    element.regionId == regionId && element.userId == userId)
                .toList();
            visitsList = visitsList
                .where((element) =>
                    element.regionId == regionId && element.userId == userId)
                .toList();
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const AppFilterWidget(
                  showRegionFilter: true,
                  showSelectedUserFilter: true,
                  showStartDateFilter: true,
                  showEndDateFilter: true,
                ),
                const Divider(),
                const SizedBox(height: 10),
                if (visitsList.isEmpty)
                  Center(
                    child: Text(
                      'No Visits Found',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                if (visitsList.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Visits Map',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child:
                                  visitAdherenceMapWidget(visits: visitsList),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Orders Map',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child: ordersMapWidget(orders: ordersList),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Card(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: OrdersSummaryTable(orders: ordersList),
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: VisitsSummaryTableWidget(visits: visitsList),
                          ),
                        ),
                      ],
                    ),
                    if (ordersList.isEmpty) const SizedBox.shrink(),
                    if (ordersList.isNotEmpty)
                      Column(
                        children: [
                          Card(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TopSalesPersonTable(orders: ordersList),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 400,
                            child: SfPieChart(
                              chartData:
                                  OrderChartUtils.sellOutAndOrdersTopProducts(
                                      orders: ordersList),
                              title: 'TOP PRODUCTS',
                            ),
                          ),
                          // const KpiWidget(),
                        ],
                      )
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}
