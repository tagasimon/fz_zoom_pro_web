import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/sub_cartegory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

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
        DataCell(Text(data[index].name)),
        DataCell(
          Consumer(
            builder: (context, ref, _) {
              final cartegoryProv = ref
                  .watch(productCartegoryByIdProvider(data[index].cartegoryId));
              return cartegoryProv.when(
                data: (subCart) {
                  return Text(subCart.name);
                },
                error: (error, stackTrace) => const Text("Error"),
                loading: () => const Text("Loading ..."),
              );
            },
          ),
        ),
        DataCell(
          Consumer(
            builder: (context, ref, _) {
              final subCartProv = ref
                  .watch(subCartegoryByIdProvider(data[index].subCartegoryId));
              return subCartProv.when(
                data: (subCart) {
                  return Text(subCart.name);
                },
                error: (error, stackTrace) => const Text("Error"),
                loading: () => const Text("Loading ..."),
              );
            },
          ),
        ),
        DataCell(Text(data[index].productVar)),
        DataCell(Text(data[index].sellingPrice.toString())),
        DataCell(Text(data[index].isActive.toString())),
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
