import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
import 'package:field_zoom_pro_web/features/visits/presentation/widgets/visit_adherence_map_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/item_per_page_widget.dart';
import 'package:field_zoom_pro_web/features/visits/providers/visits_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class VisitsScreen extends ConsumerWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsProv = ref.watch(companyVisitsAndCustomersProvider);
    final regionId = ref.watch(quickfilterNotifierProvider).region;
    final selectedUserId =
        ref.watch(quickfilterNotifierProvider).selectedUserId;
    return Scaffold(
      appBar: const CompanyAppBarWidget(title: "VISITS"),
      body: visitsProv.when(
        data: (visitsAndCustomers) {
          List<VisitModel> visits = visitsAndCustomers[0] as List<VisitModel>;
          List<CustomerModel> customers =
              visitsAndCustomers[1] as List<CustomerModel>;
          List<UserModel> users = visitsAndCustomers[2] as List<UserModel>;
          List<String> customerIds =
              visits.map((e) => e.customerId).toSet().toList();
          List<CustomerModel> filteredCustomers = customers
              .where((element) => customerIds.contains(element.id))
              .toList();
          if (regionId != null) {
            visits = visits
                .where((element) => element.regionId == regionId)
                .toList();
          }
          if (selectedUserId != null) {
            visits = visits
                .where((element) => element.userId == selectedUserId)
                .toList();
          }
          if (regionId != null && selectedUserId != null) {
            visits = visits
                .where((element) =>
                    element.regionId == regionId &&
                    element.userId == selectedUserId)
                .toList();
          }
          // replace customerId with CustomerName from the filteredCustomers List
          visits = visits.map((e) {
            final customer = filteredCustomers
                .firstWhere((element) => element.id == e.customerId);
            return e.copyWith(customerId: customer.businessName);
          }).toList();

          // replace userId with CustomerName from the users List
          visits = visits.map((e) {
            final user = users.firstWhere((element) => element.id == e.userId);
            return e.copyWith(userId: user.name);
          }).toList();

          final myData = VisitDataSourceModel(
            data: visits,
            selectedVisits: {},
            onSelected: (visit) {},
          );
          return Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppFilterWidget(
                    showRegionFilter: true,
                    showSelectedUserFilter: true,
                    showStartDateFilter: true,
                    showEndDateFilter: true,
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 5),
              visits.isEmpty
                  ? const Center(child: NothingFoundAnimation())
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 400,
                                  width: context.screenWidth * 0.45,
                                  child: Stack(
                                    children: [
                                      visitAdherenceMapWidget(visits: visits),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: context.paddingLow,
                                          child: const Text(
                                            'Users Locations at Visit Time',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(),
                                SizedBox(
                                  height: 400,
                                  width: context.screenWidth * 0.45,
                                  child: Stack(
                                    children: [
                                      customersMapWidget(
                                          customers: filteredCustomers),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: context.paddingLow,
                                          child: const Text(
                                            'Customers Visited Physical Locations',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: PaginatedDataTable(
                                    columns: const [
                                      DataColumn(label: Text("USER")),
                                      DataColumn(label: Text("REGION")),
                                      DataColumn(label: Text("CUSTOMER")),
                                      DataColumn(label: Text("START TIME")),
                                      DataColumn(label: Text("END TIME")),
                                      DataColumn(label: Text("VISIT DURATION")),
                                    ],
                                    source: myData,
                                    header: Text("VISITS (${visits.length})"),
                                    rowsPerPage: ref
                                        .watch(productFilterNotifierProvider)
                                        .itemCount,
                                    sortColumnIndex: 0,
                                    sortAscending: false,
                                    showCheckboxColumn: false,
                                    actions: const [ItemPerPageWidget()],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class VisitDataSourceModel extends DataTableSource {
  final List<VisitModel> data;
  final Set<VisitModel> selectedVisits;
  final Function(VisitModel visit) onSelected;

  final timeFormat = DateFormat("hh:mm a");

  VisitDataSourceModel({
    required this.data,
    required this.selectedVisits,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(data[index].userId)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(Text(data[index].customerId)),
        DataCell(
            Text(timeFormat.format(data[index].visitStartDate as DateTime))),
        DataCell(Text(timeFormat.format(data[index].visitEndDate as DateTime))),
        DataCell(
          Text(
            "${visitDuration(startDate: data[index].visitStartDate as DateTime, endDate: data[index].visitEndDate as DateTime)} Minutes",
          ),
        ),
      ],
      selected: selectedVisits.contains(data[index]),
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
  int get selectedRowCount => selectedVisits.length;
}

int getDaysDifference(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  return diff.inDays;
}

int visitDuration({required DateTime startDate, required DateTime endDate}) {
  final diff = endDate.difference(startDate);
  return diff.inMinutes + (diff.inSeconds % 60 == 0 ? 0 : 1);
}
