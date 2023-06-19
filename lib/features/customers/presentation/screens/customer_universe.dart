import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/core/providers/routes_provider.dart';
import 'package:field_zoom_pro_web/features/customers/models/customer_data_source_model.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class CustomerUniverse extends ConsumerWidget {
  const CustomerUniverse({Key? key}) : super(key: key);
  static const routeName = "registered_customers";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(filterNotifierProvider).region;
    final agentCustomersProv = ref.watch(customersProviderProvider);
    return agentCustomersProv.when(
      data: (customers) {
        final myData = CustomerDataSourceModel(
          data: customers,
          selectedCustomers: {},
          onSelected: (cust) {},
        );
        final customersPerRouteChartData =
            CustomerChartUtils.customersPerRoute(customers: customers);
        final customersPerBusinessTypeChartData =
            CustomerChartUtils.customersPerBusinessType(customers: customers);
        final customersPerDistrictChartData =
            CustomerChartUtils.customersPerDistrict(customers: customers);
        return Scaffold(
            appBar: AppBar(
              title: const Text("CUSTOMERS"),
              actions: const [
                AppFilterWidget(
                  showRegionFilter: true,
                  showRouteFilter: false,
                  showSelectedUserFilter: false,
                  showEndDateFilter: false,
                  showStartDateFilter: false,
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (customers.isEmpty)
                  const Center(
                    child: NothingFoundAnimation(
                      title: 'No Customers Found',
                      url:
                          "https://assets10.lottiefiles.com/packages/lf20_WpDG3calyJ.json",
                    ),
                  ),
                if (customers.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                customersMapWidget(customers: customers),
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        ' Customers Map',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 400,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SfPieChart(
                                    chartData:
                                        customersPerBusinessTypeChartData,
                                    title: 'BUSINESS TYPES',
                                  ),
                                ),
                                Expanded(
                                  child: Consumer(
                                    builder: (context, ref, child) {
                                      final getRouteByIdProv = ref.watch(
                                          routesByIdProvider(
                                              customersPerRouteChartData));
                                      return getRouteByIdProv.when(
                                        data: (routesChartData) {
                                          return SfDonutChart(
                                            chartData: routesChartData,
                                            title: 'ROUTES',
                                          );
                                        },
                                        loading: () => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        error: (e, s) =>
                                            const SizedBox.shrink(),
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SfDonutChart(
                                    chartData: customersPerDistrictChartData,
                                    title: 'DISTRICTS',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("CONTACT NAME")),
                              DataColumn(label: Text("BUSINESS NAME")),
                              DataColumn(label: Text("BUSINESS TYPE")),
                              DataColumn(label: Text("REGION")),
                              DataColumn(label: Text("ROUTE")),
                              DataColumn(label: Text("PHONE 1")),
                              DataColumn(label: Text("DISTRICT")),
                              DataColumn(label: Text("GPS")),
                              DataColumn(label: Text("DESC")),
                            ],
                            source: myData,
                            header: region == null
                                ? Text("CUSTOMERS (${customers.length})")
                                : Text("$region (${customers.length})"),
                            rowsPerPage: 10,
                            sortColumnIndex: 0,
                            sortAscending: false,
                            actions: const [
                              // TODO Make this work
                              // Row(
                              //   children: [
                              //     TextButton.icon(
                              //       onPressed: () {
                              //         Fluttertoast.showToast(
                              //             msg: "Coming Soon :)");
                              //       },
                              //       icon: const Icon(Icons.download),
                              //       label: const Text("Download"),
                              //     )
                              //   ],
                              // )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ));
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('CUSTOMERS')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('CUSTOMERS')),
          body: Center(child: Text("Error: $error")),
        );
      },
    );
  }
}
