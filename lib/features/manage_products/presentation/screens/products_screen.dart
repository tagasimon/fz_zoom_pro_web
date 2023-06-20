import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/copy_product_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/alert_dialog_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_details_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_sub_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/active_product_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/products_table_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

enum ProductScreenActions { selectProduct, duplicate }

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  static const routeName = "registeredCustomersScreen";

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String? selectedProductId;
  ProductScreenActions? selectedAction;
  int itemPerPage = 8;
  final List<int> dropDownItems =
      List.generate(100, (index) => (index + 1) * 3);
  @override
  Widget build(BuildContext context) {
    final productsProv = ref.watch(watchProductsProvider);
    final state = ref.watch(productsControllerProvider);
    ref.listen(productsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return productsProv.when(
      data: (customers) {
        final myData = ProductDataSourceModel(
          data: customers,
          selectedProductId: selectedProductId,
          onSelected: (productId) {
            if (selectedProductId == null) {
              setState(() {
                selectedProductId = productId;
                selectedAction = ProductScreenActions.selectProduct;
              });
              return;
            }
            setState(() {
              selectedAction = null;
              selectedProductId = null;
            });
          },
        );
        return Scaffold(
          appBar: AppBar(
            title: const CompanyTitleWidget(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state.isLoading) const LinearProgressIndicator(),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PaginatedDataTable(
                      columns: const [
                        DataColumn(label: Text("#")),
                        DataColumn(label: Text("SYS CODE")),
                        DataColumn(label: Text("NAME")),
                        DataColumn(label: Text("CARTEGORY")),
                        DataColumn(label: Text("SUB CARTEGORY")),
                        DataColumn(label: Text("VAR")),
                        DataColumn(label: Text("SELLING PRICE")),
                        DataColumn(label: Text("IMG")),
                        DataColumn(label: Text("IS ACTIVE")),
                      ],
                      source: myData,
                      header: const Text("PRODUCTS"),
                      rowsPerPage: itemPerPage,
                      actions: selectedProductId == null
                          ? [
                              Row(
                                children: [
                                  DropdownButton<int>(
                                    hint: Text('$itemPerPage Products'),
                                    items: dropDownItems
                                        .map((e) => DropdownMenuItem<int>(
                                              value: e,
                                              child: Text(e.toString()),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val == null) return;
                                      setState(() => itemPerPage = val);
                                    },
                                  ),
                                  const VerticalDivider(),
                                  const ProductsTableOptionsWidget(),
                                ],
                              )
                            ]
                          : [
                              ActiveProductWidget(
                                onCopy: () {
                                  setState(() {
                                    selectedAction =
                                        ProductScreenActions.duplicate;
                                  });
                                },
                                onDelete: () async {
                                  final bool? confirm = await showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialogWidget(
                                      title: "Delete Product",
                                      subTitle:
                                          "Are you sure you want to delete this product?",
                                      yesActionText: "Delete",
                                      noActionText: "Cancel",
                                    ),
                                  );
                                  setState(() => selectedAction = null);
                                  if (confirm == null || !confirm) return;

                                  final user = ref
                                      .read(filterNotifierProvider)
                                      .loggedInuser;
                                  final success = await ref
                                      .read(productsControllerProvider.notifier)
                                      .deleteProductById(
                                          companyId: user!.companyId,
                                          productId: selectedProductId!);
                                  if (success) {
                                    setState(() => selectedProductId = null);
                                    Fluttertoast.showToast(msg: "SUCCESS :)");
                                  }
                                },
                              ),
                            ],
                      showCheckboxColumn: true,
                      showFirstLastButtons: true,
                    ),
                  ),
                  const VerticalDivider(),
                  if (selectedProductId != null)
                    Expanded(
                      flex: 1,
                      child: Builder(
                        builder: (context) {
                          final child = switch (selectedAction) {
                            ProductScreenActions.selectProduct =>
                              ProductDetailsScreen(id: selectedProductId!),
                            ProductScreenActions.duplicate => CopyProductScreen(
                                selectedProductId: selectedProductId!,
                                onCancel: () {
                                  setState(() {
                                    selectedProductId = null;
                                    selectedAction = null;
                                  });
                                },
                              ),
                            _ => const SizedBox.shrink()
                          };
                          return child;
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }
}

class ProductDataSourceModel extends DataTableSource {
  final List<ProductModel> data;
  final String? selectedProductId;
  final Function(String) onSelected;

  final dateFormat = DateFormat("dd/MM/yyyy");

  ProductDataSourceModel({
    required this.data,
    required this.selectedProductId,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(data[index].systemCode)),
        DataCell(Text(data[index].name)),
        DataCell(ProductCartegoryWidget(cartegoryId: data[index].cartegoryId)),
        DataCell(ProductSubCartegoryWidget(id: data[index].subCartegoryId)),
        DataCell(Text(data[index].productVar)),
        DataCell(Text(data[index].sellingPrice.toString())),
        DataCell(CircleImageWidget(url: data[index].productImg!)),
        DataCell(
          Switch(
            value: data[index].isActive,
            onChanged: (val) {
              // TODO Implement this
            },
          ),
        )
      ],
      selected: selectedProductId == data[index].id,
      onSelectChanged: (val) {
        onSelected(data[index].id);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedProductId == null ? 0 : 1;
}
