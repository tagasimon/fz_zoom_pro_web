import 'package:field_zoom_pro_web/core/presentation/widgets/get_user_names_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class OrdersBySalesRep extends ConsumerWidget {
  final List<OrderModel> orders;
  final List<PayementModel> collections;
  final List<VisitModel> visits;
  const OrdersBySalesRep(
      {super.key,
      required this.orders,
      required this.collections,
      required this.visits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mFormat = NumberFormat("UGX #,###.0");
    final List<SalesRepSummaryModel> salesRepSummaryList =
        SalesRepSummaryUtils.calculateSalesRepSummaryStats(
            orders: orders, visits: visits, collections: collections);
    return Card(
      child: DataTable(
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('SALES REP')),
          DataColumn(label: Text('tORDERS')),
          DataColumn(label: Text('tPENDING')),
          DataColumn(label: Text('tDELIVERED')),
          DataColumn(label: Text('tCANCELLED')),
          DataColumn(label: Text('tCOLLECTIONS')),
          DataColumn(label: Text('#VISITS')),
        ],
        rows: [
          for (final salesRep in salesRepSummaryList)
            DataRow(cells: [
              DataCell(GetUserNamesWidget(userId: salesRep.salesRepId)),
              DataCell(SelectableText("${salesRep.totalOrders}")),
              DataCell(SelectableText("${salesRep.totalOrdersPending}")),
              DataCell(SelectableText("${salesRep.totalOrdersDelivered}")),
              DataCell(SelectableText("${salesRep.totalOrdersCancelled}")),
              DataCell(
                  SelectableText(mFormat.format(salesRep.totalCollections))),
              DataCell(SelectableText("${salesRep.totalVisits}")),
            ]),
        ],
      ),
    );
  }
}
