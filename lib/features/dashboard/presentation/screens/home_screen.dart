import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/sales_rep_summary_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_map_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_summary_table.dart';
import 'package:field_zoom_pro_web/features/dashboard/providers/dashboard_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dasboardProv = ref.watch(dashboardProvider);
    final regionId = ref.watch(quickfilterNotifierProvider).region;
    final selectedUserId =
        ref.watch(quickfilterNotifierProvider).selectedUserId;
    return Scaffold(
      appBar: const CompanyAppBarWidget(),
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

          return Column(
            children: [
              const AppFilterWidget(
                showRegionFilter: true,
                showSelectedUserFilter: true,
                showStartDateFilter: true,
                showEndDateFilter: true,
              ),
              const Divider(),
              const SizedBox(height: 5),
              if (ordersList.isEmpty &&
                  visitsList.isEmpty &&
                  paymentsList.isEmpty)
                const Expanded(child: NothingFoundAnimation()),
              if (ordersList.isNotEmpty ||
                  visitsList.isNotEmpty ||
                  paymentsList.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        if (ordersList.isEmpty)
                          const Center(child: NothingFoundAnimation()),
                        if (ordersList.isNotEmpty)
                          SizedBox(
                            height: 500,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Card(
                                    child: SizedBox(
                                      width: context.screenWidth * 0.4,
                                      // height: 400,
                                      child: OrdersSummaryTable(
                                          orders: ordersList),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    child: SizedBox(
                                        width: context.screenWidth * 0.4,
                                        child: Stack(
                                          children: [
                                            ordersMapWidget(orders: ordersList),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                  padding: context.paddingLow,
                                                  child: const Text(
                                                    'Orders Map',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: SalesRepSummaryWidget(
                                orders: ordersList,
                                collections: paymentsList,
                                visits: visitsList,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: context.screenWidth * 0.3,
                                  child: SfPieChart(
                                    chartData: OrderChartUtils
                                        .sellOutAndOrdersTopProducts(
                                            orders: ordersList),
                                    title: 'TOP PRODUCTS',
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(child: Icon(Icons.bar_chart)),
                              ),
                              const Expanded(
                                child: SizedBox(child: Icon(Icons.pie_chart)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
