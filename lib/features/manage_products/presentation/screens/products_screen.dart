import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/copy_product_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/alert_dialog_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_details_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_sub_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/products_filter_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/products_table_options_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/active_product_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
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
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    final productsProv = ref.watch(watchProductsProvider);
    final state = ref.watch(productsControllerProvider);
    ref.listen(productsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    final filteredCartegory =
        ref.watch(productFilterNotifierProvider).cartegory;
    final filteredSubCartegory =
        ref.watch(productFilterNotifierProvider).subCartegory;

    return productsProv.when(
      data: (products) {
        if (filteredCartegory != null && filteredSubCartegory != null) {
          products = products
              .where((element) =>
                  element.cartegoryId == filteredCartegory &&
                  element.subCartegoryId == filteredSubCartegory)
              .toList();
        }
        if (filteredCartegory != null && filteredSubCartegory == null) {
          products = products
              .where((element) => element.cartegoryId == filteredCartegory)
              .toList();
        }

        if (filteredCartegory == null && filteredSubCartegory != null) {
          products = products
              .where(
                  (element) => element.subCartegoryId == filteredSubCartegory)
              .toList();
        }

        if (searchValue != null) {
          products = products
              .where((element) =>
                  element.name.toLowerCase().contains(searchValue!))
              .toList();
        }

        final myData = ProductDataSourceModel(
          data: products,
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
          appBar: const CompanyAppBarWidget(title: "PRODUCTS")
              as PreferredSizeWidget?,

          //  AppBar(
          //   title: const CompanyAppBarWidget(),
          //   actions: const [
          //     CustomSwitchWidget(),
          //     RequestFullScreenWidget(),
          //   ],
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ProductsFilterWidget(),
              const Divider(),
              if (state.isLoading) const LinearProgressIndicator(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: PaginatedDataTable(
                      columns: const [
                        DataColumn(label: Text("#")),
                        DataColumn(label: Text("SYS CODE")),
                        DataColumn(label: Text("NAME")),
                        DataColumn(label: Text("SUB CARTEGORY")),
                        DataColumn(label: Text("CARTEGORY")),
                        DataColumn(label: Text("VARIATION")),
                        DataColumn(label: Text("UNIVERSE PRICE")),
                        DataColumn(label: Text("SALES PRICE")),
                        DataColumn(label: Text("WHOLESALE PRICE")),
                        DataColumn(label: Text("IS ACTIVE")),
                      ],
                      source: myData,
                      header: const Text("PRODUCTS"),
                      rowsPerPage:
                          ref.watch(productFilterNotifierProvider).itemCount,
                      actions: selectedProductId == null
                          ? [
                              ProductsTableOptionsWidget(
                                onChanged: (search) {
                                  setState(() => searchValue = search);
                                },
                              ),
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
                                      .read(sessionNotifierProvider)
                                      .loggedInUser;
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
                              ProductDetailsScreen(
                                id: selectedProductId!,
                                onEscape: () {
                                  setState(() {
                                    selectedProductId = null;
                                    selectedAction = null;
                                  });
                                },
                              ),
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
        DataCell(Text(data[index].systemCode ?? "")),
        DataCell(Text(data[index].name)),
        DataCell(ProductSubCartegoryWidget(id: data[index].subCartegoryId)),
        DataCell(ProductCartegoryWidget(cartegoryId: data[index].cartegoryId)),
        DataCell(Text(data[index].productVar)),
        DataCell(Text(data[index].universePrice.toString())),
        DataCell(Text(data[index].sellingPrice.toString())),
        DataCell(Text(data[index].wholesalePrice.toString())),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              return Switch(
                value: data[index].isActive,
                onChanged: (val) async {
                  final success = await ref
                      .read(productsControllerProvider.notifier)
                      .updateProductByCompanyId(
                        product: data[index].copyWith(isActive: val),
                      );
                  if (success) {
                    Fluttertoast.showToast(msg: "SUCCESS :)");
                  }
                },
              );
            },
          ),
        )
      ],
      selected: selectedProductId == data[index].id,
      onSelectChanged: (val) => onSelected(data[index].id),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedProductId == null ? 0 : 1;
}
