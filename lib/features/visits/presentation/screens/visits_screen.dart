import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_user_names_widget.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/get_customer_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/visit_adherence_map_widget.dart';
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
    final visitsProv = ref.watch(companyVisitsProvider);
    final regionId = ref.watch(quickfilterNotifierProvider).region;
    final selectedUserId =
        ref.watch(quickfilterNotifierProvider).selectedUserId;
    return Scaffold(
      appBar: const CompanyAppBarWidget(title: "VISITS"),
      body: visitsProv.when(
        data: (data) {
          if (regionId != null) {
            data =
                data.where((element) => element.regionId == regionId).toList();
          }
          if (selectedUserId != null) {
            data = data
                .where((element) => element.userId == selectedUserId)
                .toList();
          }
          if (regionId != null && selectedUserId != null) {
            data = data
                .where((element) =>
                    element.regionId == regionId &&
                    element.userId == selectedUserId)
                .toList();
          }
          if (data.isEmpty) {
            return const Center(child: Text('No data found'));
          }
          final myData = VisitDataSourceModel(
            data: data,
            selectedVisits: {},
            onSelected: (visit) {},
          );
          return Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemPerPageWidget(),
                  SizedBox(width: 10),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: visitAdherenceMapWidget(visits: data),
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
                              header: Text("VISITS (${data.length})"),
                              rowsPerPage: ref
                                  .watch(productFilterNotifierProvider)
                                  .itemCount,
                              sortColumnIndex: 0,
                              sortAscending: false,
                              showCheckboxColumn: false,
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
        DataCell(GetUserNamesWidget(userId: data[index].userId)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(GetCustomerWidget(customerId: data[index].customerId)),
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
