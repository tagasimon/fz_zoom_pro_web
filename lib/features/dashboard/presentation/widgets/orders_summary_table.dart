import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class OrdersSummaryTable extends ConsumerWidget {
  final List<OrderModel> orders;
  const OrdersSummaryTable({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mFormat = NumberFormat("UGX #,###.0");
    final totalOrders = SaleOutOrderUtils.totalOrders(orders: orders);
    final totalOrderAmnt =
        SaleOutOrderUtils.totalNotCancelledOrdersAmount(orders: orders);
    final avgOrderAmnt =
        SaleOutOrderUtils.avgNotCancelledOrderAmount(orders: orders);
    final numPendingOrders =
        SaleOutOrderUtils.totalOrdersPending(orders: orders);
    final numDeliveredOrders =
        SaleOutOrderUtils.totalOrdersDelivered(orders: orders);
    final numClosedOrders = SaleOutOrderUtils.totalOrdersClosed(orders: orders);
    final numCancelledOrders =
        SaleOutOrderUtils.totalOrdersCancelled(orders: orders);
    final medianOrderAmt = SaleOutOrderUtils.medianOrderAmount(orders: orders);

    final scrollController = ScrollController();
    if (scrollController.hasClients) {
      scrollController.jumpTo(50.0);
    }
    return DataTable(
      showBottomBorder: true,
      columns: const [
        DataColumn(label: Text('KPI')),
        DataColumn(label: Text('VALUE')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('TOTAL ORDERS')),
          DataCell(Text('$totalOrders')),
        ]),
        DataRow(cells: [
          const DataCell(Text('PENDING ORDERS')),
          DataCell(Text('$numPendingOrders')),
        ]),
        DataRow(cells: [
          const DataCell(Text('DELIVERED ORDERS')),
          DataCell(Text('$numDeliveredOrders')),
        ]),
        DataRow(cells: [
          const DataCell(Text('CLOSED ORDERS')),
          DataCell(Text('$numClosedOrders')),
        ]),
        DataRow(cells: [
          const DataCell(Text('CANCELLED ORDERS')),
          DataCell(Text('$numCancelledOrders')),
        ]),
        DataRow(cells: [
          const DataCell(Text('AVG ORDER VALUE')),
          DataCell(Text(mFormat.format(avgOrderAmnt))),
        ]),
        DataRow(cells: [
          const DataCell(Text('MEDIAN ORDER VALUE')),
          DataCell(Text(mFormat.format(medianOrderAmt))),
        ]),
        DataRow(cells: [
          const DataCell(Text('TOTAL ORDERS')),
          DataCell(Text(mFormat.format(totalOrderAmnt))),
        ]),
      ],
    );
  }
}
