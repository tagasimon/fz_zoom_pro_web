import 'package:field_zoom_pro_web/features/dashboard/presentation/widgets/orders_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class OrdersSummaryTable extends ConsumerWidget {
  final List<OrderModel> orders;
  const OrdersSummaryTable({super.key, required this.orders});

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
          DataCell(
            OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  showDragHandle: true,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (builder) => OrdersBottomSheetWidget(
                    orderType: 'ALL',
                    orders: orders,
                  ),
                );
              },
              label: Text('$totalOrders'),
              icon: const Icon(Icons.arrow_right_sharp),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(Text('PENDING ORDERS')),
          DataCell(
            OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  showDragHandle: true,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (builder) => OrdersBottomSheetWidget(
                    orderType: 'PENDING',
                    orders: orders
                        .where((element) => element.status == 'PENDING')
                        .toList(),
                  ),
                );
              },
              label: Text('$numPendingOrders'),
              icon: const Icon(Icons.arrow_right_sharp),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(Text('DELIVERED ORDERS')),
          DataCell(
            OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  showDragHandle: true,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (builder) => OrdersBottomSheetWidget(
                    orderType: 'DELIVERED',
                    orders: orders
                        .where((element) => element.status == 'DELIVERED')
                        .toList(),
                  ),
                );
              },
              label: Text('$numDeliveredOrders'),
              icon: const Icon(Icons.arrow_right_sharp),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(Text('CLOSED ORDERS')),
          DataCell(
            OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  showDragHandle: true,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (builder) => OrdersBottomSheetWidget(
                    orderType: 'CLOSED',
                    orders: orders
                        .where((element) => element.status == 'CLOSED')
                        .toList(),
                  ),
                );
              },
              label: Text('$numClosedOrders'),
              icon: const Icon(Icons.arrow_right_sharp),
            ),
          ),
        ]),
        DataRow(cells: [
          const DataCell(Text('CANCELLED ORDERS')),
          DataCell(
            OutlinedButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  showDragHandle: true,
                  enableDrag: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  context: context,
                  builder: (builder) => OrdersBottomSheetWidget(
                    orderType: 'CANCELLED',
                    orders: orders
                        .where((element) => element.status == 'CANCELLED')
                        .toList(),
                  ),
                );
              },
              label: Text('$numCancelledOrders'),
              icon: const Icon(Icons.arrow_right_sharp),
            ),
          ),
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
