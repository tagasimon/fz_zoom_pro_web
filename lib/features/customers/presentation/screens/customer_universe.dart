import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_route_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/core/providers/routes_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/item_per_page_widget.dart';
import 'package:field_zoom_pro_web/features/orders/providers/orders_providers.dart';
import 'package:field_zoom_pro_web/features/visits/providers/visits_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class CustomerUniverse extends ConsumerStatefulWidget {
  const CustomerUniverse({Key? key}) : super(key: key);
  static const routeName = "registered_customers";

  @override
  ConsumerState<CustomerUniverse> createState() => _CustomerUniverseState();
}

class _CustomerUniverseState extends ConsumerState<CustomerUniverse> {
  String? searchTerm;
  @override
  Widget build(BuildContext context) {
    final region = ref.watch(quickfilterNotifierProvider).region;
    final agentCustomersProv = ref.watch(customersProviderProvider);
    return agentCustomersProv.when(
      data: (customers) {
        if (region != null && region.isNotEmpty) {
          customers =
              customers.where((element) => element.regionId == region).toList();
        }
        if (searchTerm != null && searchTerm!.isNotEmpty) {
          customers = customers
              .where((element) =>
                  element.businessName
                      .toLowerCase()
                      .contains(searchTerm!.toLowerCase()) ||
                  element.name
                      .toLowerCase()
                      .contains(searchTerm!.toLowerCase()))
              .toList();
        }
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
            appBar: const CompanyAppBarWidget(title: "CUSTOMERS"),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ItemPerPageWidget(),
                    SizedBox(width: 10),
                    AppFilterWidget(
                      showRegionFilter: true,
                      showRouteFilter: true,
                      showSelectedUserFilter: false,
                      showEndDateFilter: false,
                      showStartDateFilter: false,
                    ),
                  ],
                ),
                const Divider(),
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
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                      padding: context.paddingLow,
                                      child: const Text(
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
                          const SizedBox(height: 5),
                          PaginatedDataTable(
                            columns: const [
                              // DataColumn(label: Text("#")),
                              DataColumn(label: Text("CONTACT NAME")),
                              DataColumn(label: Text("BUSINESS NAME")),
                              DataColumn(label: Text("LAST VISIT DATE")),
                              DataColumn(label: Text("LAST ORDER DATE")),
                              DataColumn(label: Text("LAST ORDER AMOUNT")),
                              DataColumn(label: Text("BUSINESS TYPE")),
                              DataColumn(label: Text("REGION")),
                              DataColumn(label: Text("ROUTE")),
                              DataColumn(label: Text("PHONE 1")),
                              DataColumn(label: Text("DISTRICT")),
                              DataColumn(label: Text("DESC")),
                            ],
                            source: myData,
                            header: region == null
                                ? Text("CUSTOMERS (${customers.length})")
                                : Text("$region (${customers.length})"),
                            rowsPerPage: ref
                                .watch(productFilterNotifierProvider)
                                .itemCount,
                            sortColumnIndex: 0,
                            sortAscending: false,
                            actions: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: context.screenWidth * 0.2,
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() => searchTerm = value);
                                      },
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Search Customer Name or Business Name"),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
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
                                              child:
                                                  CircularProgressIndicator()),
                                          error: (e, s) =>
                                              const SizedBox.shrink());
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: SfDonutChart(
                                      chartData: customersPerDistrictChartData,
                                      title: 'DISTRICTS'),
                                ),
                              ],
                            ),
                          ),
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
    // final number = index + 1;
    return DataRow(
      cells: [
        // DataCell(Text(number.toString())),
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].businessName)),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              final customerLastVisitProv =
                  ref.watch(customerLastVisitProvider(data[index].id));
              return customerLastVisitProv.when(
                data: (data) {
                  if (data == null) {
                    return const Text("NEVER",
                        style: TextStyle(fontSize: 12, color: Colors.red));
                  }
                  final visitDate = data.visitEndDate as DateTime;
                  final daysDiff = getDaysDifference(visitDate);
                  return daysDiff == 0
                      ? const Text("TODAY",
                          style: TextStyle(fontSize: 12, color: Colors.green))
                      : Text(
                          "$daysDiff days ago",
                          style: TextStyle(
                              fontSize: 12,
                              color: daysDiff > 30
                                  ? Colors.red
                                  : daysDiff > 15
                                      ? Colors.orange
                                      : Colors.green),
                        );
                },
                error: (e, s) => const SizedBox.shrink(),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              final customerLastOrderProv =
                  ref.watch(customerLastOrderProvider(data[index].id));
              return customerLastOrderProv.when(
                data: (data) {
                  if (data == null) {
                    return const Text("NEVER",
                        style: TextStyle(fontSize: 12, color: Colors.red));
                  }
                  final daysDiff =
                      getDaysDifference(data.createdAt as DateTime);
                  return daysDiff == 0
                      ? const Text("TODAY",
                          style: TextStyle(fontSize: 12, color: Colors.green))
                      : Text(
                          "$daysDiff days ago",
                          style: TextStyle(
                              fontSize: 12,
                              color: daysDiff > 7
                                  ? Colors.red
                                  : daysDiff > 3
                                      ? Colors.orange
                                      : Colors.green),
                        );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const SizedBox.shrink(),
              );
            },
          ),
        ),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              final customerLastOrderProv =
                  ref.watch(customerLastOrderProvider(data[index].id));
              return customerLastOrderProv.when(
                data: (data) {
                  final mFormat = NumberFormat("UGX #,###");
                  if (data == null) {
                    return const Text("UGX 0.00",
                        style: TextStyle(fontSize: 12, color: Colors.red));
                  }
                  return Text(
                    mFormat.format(data.amount),
                    style: const TextStyle(fontSize: 12),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const SizedBox.shrink(),
              );
            },
          ),
        ),
        DataCell(Text(data[index].businessType)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(GetRouteWidget(routeId: data[index].routeId)),
        DataCell(Text(data[index].phoneNumber)),
        DataCell(Text(data[index].district)),
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

int getDaysDifference(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  return diff.inDays;
}
