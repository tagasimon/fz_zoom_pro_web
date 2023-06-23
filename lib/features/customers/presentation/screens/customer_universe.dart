import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/custom_switch_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_route_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/request_full_screen_widget.dart';
import 'package:field_zoom_pro_web/core/providers/routes_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class CustomerUniverse extends ConsumerWidget {
  const CustomerUniverse({Key? key}) : super(key: key);
  static const routeName = "registered_customers";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(sessionNotifierProvider).region;
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
                CustomSwitchWidget(),
                RequestFullScreenWidget(),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppFilterWidget(
                  showRegionFilter: true,
                  showRouteFilter: true,
                  showSelectedUserFilter: false,
                  showEndDateFilter: false,
                  showStartDateFilter: false,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
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

class CustomerDataSourceModel extends DataTableSource {
  final List<CustomerModel> data;
  final Set<CustomerModel> selectedCustomers;
  final Function(CustomerModel customer) onSelected;

  final dateFormat = DateFormat("dd/MM/yyyy");

  CustomerDataSourceModel({
    required this.data,
    required this.selectedCustomers,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    final number = index + 1;
    return DataRow(
      cells: [
        DataCell(Text(number.toString())),
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].businessName)),
        DataCell(Text(data[index].businessType)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(GetRouteWidget(routeId: data[index].routeId)),
        DataCell(Text(data[index].phoneNumber)),
        DataCell(Text(data[index].district)),
        DataCell(Text("${data[index].latitude} , ${data[index].longitude}")),
        DataCell(Text(data[index].locationDescription)),
      ],
      selected: selectedCustomers.contains(data[index]),
      onSelectChanged: (val) {
        onSelected(data[index]);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedCustomers.length;
}
