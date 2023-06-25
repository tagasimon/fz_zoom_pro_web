import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_route_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_user_names_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/get_customer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class OrdersBottomSheetWidget extends ConsumerStatefulWidget {
  final String orderType;
  final List<OrderModel> orders;
  const OrdersBottomSheetWidget(
      {super.key, required this.orderType, required this.orders});

  @override
  ConsumerState<OrdersBottomSheetWidget> createState() =>
      _OrdersBottomSheetWidgetState();
}

class _OrdersBottomSheetWidgetState
    extends ConsumerState<OrdersBottomSheetWidget> {
  String? selectedOrderId;
  OrderModel? selectedOrder;
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    if (scrollController.hasClients) {
      scrollController.jumpTo(50.0);
    }
    final customersData = OrdersDataSourceModel(
      data: widget.orders,
      selectedOrderId: selectedOrderId,
      onSelected: (order) async {
        if (selectedOrder == null) {
          setState(() {
            selectedOrder = order;
            selectedOrderId = order.id;
          });
          return;
        }
        setState(() {
          selectedOrder = null;
          selectedOrderId = null;
        });
      },
    );
    final ordersChartData =
        OrderChartUtils.computeTopProductsChartData(sales: widget.orders);
    final selectedOrderChartData = OrderChartUtils.computeTopProductsChartData(
        sales: selectedOrder != null ? [selectedOrder!] : []);
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => context.pop(false),
                  icon: const Icon(Icons.close),
                  label: const Text("ESC"),
                ),
                const SizedBox(width: 10),
              ],
            ),
            if (customersData.rowCount == 0)
              const NothingFoundAnimation(title: "No orders found"),
            if (customersData.rowCount != 0)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text("#")),
                          DataColumn(label: Text("CREATED AT")),
                          DataColumn(label: Text("USER")),
                          DataColumn(label: Text("CUSTOMER")),
                          DataColumn(label: Text("ROUTE")),
                          DataColumn(label: Text("REGION")),
                          DataColumn(label: Text("STATUS")),
                          DataColumn(label: Text("AMOUNT")),
                        ],
                        source: customersData,
                        header: Text(
                            "${widget.orderType} ORDERS LIST (${customersData.rowCount})"),
                        rowsPerPage: 10,
                        showCheckboxColumn: true,
                        showFirstLastButtons: true,
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: selectedOrder == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                border: TableBorder.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                columns: const [
                                  DataColumn(label: Text("PRODUCT")),
                                  DataColumn(label: Text("AMOUNT")),
                                ],
                                rows: [
                                  for (var r in ordersChartData)
                                    DataRow(
                                      cells: [
                                        DataCell(Text(r.title)),
                                        DataCell(
                                          Text(NumberFormat("UGX #,##0.0")
                                              .format(r.value)),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: SfBarChart(
                                  chartData: ordersChartData,
                                  axisTitle: 'Amt in Ugx',
                                  title: "TOP 10 PRODUCTS",
                                  height: 400,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ORDER DETAILS",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 10),
                              DataTable(
                                border: TableBorder.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                columns: const [
                                  DataColumn(label: Text("PRODUCT")),
                                  DataColumn(label: Text("AMOUNT")),
                                ],
                                rows: [
                                  for (var r in selectedOrderChartData)
                                    DataRow(
                                      cells: [
                                        DataCell(Text(r.title)),
                                        DataCell(
                                          Text(NumberFormat("UGX #,##0.0")
                                              .format(r.value)),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: SfBarChart(
                                  chartData: selectedOrderChartData,
                                  axisTitle: 'Amt in Ugx',
                                  title: "TOP 10 PRODUCTS",
                                  height: 400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class OrdersDataSourceModel extends DataTableSource {
  final List<OrderModel> data;
  final String? selectedOrderId;
  final Function(OrderModel) onSelected;

  OrdersDataSourceModel({
    required this.data,
    required this.selectedOrderId,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(DateFormat("dd-MM-yyyy")
            .format(data[index].createdAt as DateTime))),
        DataCell(GetUserNamesWidget(userId: data[index].userId)),
        DataCell(GetCustomerWidget(customerId: data[index].customerId)),
        DataCell(GetRouteWidget(routeId: data[index].routeId)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(Text(data[index].status)),
        DataCell(Text(NumberFormat("#,###").format(data[index].amount))),
      ],
      selected: selectedOrderId == data[index].id,
      onSelectChanged: (val) => onSelected(data[index]),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedOrderId == null ? 0 : 1;
}
