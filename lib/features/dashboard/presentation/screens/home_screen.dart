import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/custom_switch_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/request_full_screen_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/collections_by_sales_person.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_by_person_table.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_map_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_summary_table.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/visit_adherence_map_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/visits_summary_table_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/providers/dashboard_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cUser = ref.watch(sessionNotifierProvider).loggedInUser;
    final dasboardProv = ref.watch(dashboardProvider);
    final regionId = ref.watch(quickfilterNotifierProvider).region;
    final selectedUserId =
        ref.watch(quickfilterNotifierProvider).selectedUserId;
    return Scaffold(
      appBar: AppBar(
        title: cUser?.companyId == null
            ? const Text("Home Screen")
            : const CompanyTitleWidget(),
        actions: const [
          CustomSwitchWidget(),
          RequestFullScreenWidget(),
        ],
      ),
      body: dasboardProv.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: NothingFoundAnimation());
          }
          List<OrderModel> ordersList = data[0] as List<OrderModel>;
          List<VisitModel> visitsList = data[1] as List<VisitModel>;
          List<PayementModel> paymentsList = data[2] as List<PayementModel>;

          if (regionId != null) {
            ordersList = ordersList
                .where((element) => element.regionId == regionId)
                .toList();
            visitsList = visitsList
                .where((element) => element.regionId == regionId)
                .toList();
            paymentsList = paymentsList
                .where((element) => element.regionId == regionId)
                .toList();
          }
          if (selectedUserId != null) {
            ordersList = ordersList
                .where((element) => element.userId == selectedUserId)
                .toList();
            visitsList = visitsList
                .where((element) => element.userId == selectedUserId)
                .toList();
            paymentsList = paymentsList
                .where((element) => element.regionId == selectedUserId)
                .toList();
          }
          if (regionId != null && selectedUserId != null) {
            ordersList = ordersList
                .where((element) =>
                    element.regionId == regionId &&
                    element.userId == selectedUserId)
                .toList();
            visitsList = visitsList
                .where((element) =>
                    element.regionId == regionId &&
                    element.userId == selectedUserId)
                .toList();
            paymentsList = paymentsList
                .where((element) =>
                    element.regionId == regionId &&
                    element.receivedBy == selectedUserId)
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

                // if (ordersList.isEmpty &&
                //     visitsList.isEmpty &&
                //     paymentsList.isEmpty)
                //   const Center(child: NothingFoundAnimation()),

                // MAPS ROW WIDGET
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
                          if (visitsList.isNotEmpty)
                            SizedBox(
                              height: 400,
                              child:
                                  visitAdherenceMapWidget(visits: visitsList),
                            )
                          else
                            Center(
                              child: Text(
                                'No Visits Found',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
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
                          if (ordersList.isNotEmpty)
                            SizedBox(
                              height: 400,
                              child: ordersMapWidget(orders: ordersList),
                            )
                          else
                            Center(
                              child: Text(
                                'No Orders Found',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "ORDERS SUMMARY",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Card(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: OrdersSummaryTable(orders: ordersList),
                          ),
                        ),
                        Text(
                          "VISIT SUMMARY",
                          style: Theme.of(context).textTheme.labelLarge,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "TOTAL ORDERS BY SALES PERSON",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Card(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: OrdersBySalesRep(orders: ordersList),
                            ),
                          ),
                          Text(
                            "COLLECTIONS BY SALES PERSON",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          Card(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: CollectionsBySalesPerson(
                                  collections: paymentsList),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 400,
                            child: SfPieChart(
                              chartData:
                                  OrderChartUtils.sellOutAndOrdersTopProducts(
                                      orders: ordersList),
                              title: 'TOP PRODUCTS',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) {
          debugPrint("Error : $e");
          debugPrint("Stack : $s");
          return Center(
            child: Text(
              'Error: ${e.toString()}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        },
      ),
    );
  }
}
