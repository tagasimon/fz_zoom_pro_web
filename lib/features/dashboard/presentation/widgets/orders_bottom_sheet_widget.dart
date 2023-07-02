import 'package:cached_network_image/cached_network_image.dart';
import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_route_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_user_names_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/nothing_found_animation.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/get_customer_widget.dart';
import 'package:field_zoom_pro_web/features/dashboard/providers/payment_providers.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/item_per_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // final ordersChartData =
    //     OrderChartUtils.computeTopProductsChartData(sales: widget.orders);
    final selectedOrderChartData = OrderChartUtils.computeTopProductsChartData(
        sales: selectedOrder != null ? [selectedOrder!] : []);
    final dState = ref.watch(uploadImageControllerProvider);
    ref.listen(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
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
                          DataColumn(label: Text("CREATED AT")),
                          DataColumn(label: Text("USER")),
                          DataColumn(label: Text("CUSTOMER")),
                          DataColumn(label: Text("STATUS")),
                          DataColumn(label: Text("AMOUNT")),
                          DataColumn(label: Text("ROUTE")),
                          DataColumn(label: Text("REGION")),
                        ],
                        source: customersData,
                        header: Text(
                            "${widget.orderType} ORDERS (${customersData.rowCount})"),
                        rowsPerPage:
                            ref.watch(productFilterNotifierProvider).itemCount,
                        showCheckboxColumn: true,
                        showFirstLastButtons: true,
                        actions: const [ItemPerPageWidget()],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  if (selectedOrder != null)
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "ORDER BREAKDOWN",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 10),
                                for (var r in selectedOrderChartData)
                                  Card(
                                    child: ListTile(
                                      dense: true,
                                      title: Text(r.title),
                                      subtitle: Text(
                                        NumberFormat("UGX #,##0.0")
                                            .format(r.value),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Consumer(
                                  builder: (context, ref, child) {
                                    final collectionsProv = ref.watch(
                                      orderPayementsProvider(selectedOrder!.id),
                                    );
                                    return collectionsProv.when(
                                      data: (data) {
                                        if (data.isEmpty) {
                                          return const NothingFoundAnimation(
                                              title: "No collections found");
                                        }
                                        return Column(
                                          children: [
                                            Text(
                                              "COLLECTIONS",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            const SizedBox(height: 10),
                                            for (var r in data)
                                              Card(
                                                child: ListTile(
                                                  dense: true,
                                                  title: GetUserNamesWidget(
                                                      userId: r.receivedBy),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(NumberFormat(
                                                              "UGX #,##0.0")
                                                          .format(r.amount)),
                                                      Text(DateFormat(
                                                              "dd-MMMM-yyyy hh:mm a")
                                                          .format(r.receivedAt
                                                              as DateTime))
                                                    ],
                                                  ),
                                                  leading: dState.isLoading
                                                      ? const CircularProgressIndicator()
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            final url = Uri.parse(
                                                                r.evidenceLink);
                                                            if (!await launchUrl(
                                                                url)) {
                                                              throw 'Could not launch $url';
                                                            }
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Downloading...");
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                                  imageUrl: r
                                                                      .evidenceLink,
                                                                  errorWidget: (c,
                                                                          e,
                                                                          s) =>
                                                                      const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                  progressIndicatorBuilder: (c,
                                                                          s,
                                                                          d) =>
                                                                      const Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      )),
                                                        ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                      loading: () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (e, s) => const Center(
                                        child: Text("Error"),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          )
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
        DataCell(Text(DateFormat("dd-MMMM-yyyy")
            .format(data[index].createdAt as DateTime))),
        DataCell(GetUserNamesWidget(userId: data[index].userId)),
        DataCell(GetCustomerWidget(customerId: data[index].customerId)),
        DataCell(Text(data[index].status)),
        DataCell(Text(NumberFormat("#,###").format(data[index].amount))),
        DataCell(GetRouteWidget(routeId: data[index].routeId)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
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
