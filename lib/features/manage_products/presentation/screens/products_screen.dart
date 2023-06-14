import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/copy_product_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_details_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_sub_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/active_product_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/products_table_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  int flex = 2;
  @override
  Widget build(BuildContext context) {
    final productsProv = ref.watch(watchProductsProvider);
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
            centerTitle: false,
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                  rowsPerPage: 10,
                  sortColumnIndex: 0,
                  sortAscending: false,
                  actions: selectedProductId == null
                      ? [const ProductsTableOptionsWidget()]
                      : [
                          ActiveProductWidget(
                            onCopy: () {
                              setState(() {
                                selectedAction = ProductScreenActions.duplicate;
                              });
                            },
                            onDelete: () {},
                          ),
                        ],
                  showCheckboxColumn: true,
                  showFirstLastButtons: true,
                ),
              ),
              const VerticalDivider(),
              selectedProductId == null
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final child = switch (selectedAction) {
                            ProductScreenActions.selectProduct =>
                              ProductDetailsScreen(
                                id: selectedProductId!,
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
                            _ => Container(),
                          };
                          return child;
                        },
                      ),
                    ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('PRODUCTS')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('PRODUCTS')),
          body: Center(child: Text("Error: $error")),
        );
      },
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
