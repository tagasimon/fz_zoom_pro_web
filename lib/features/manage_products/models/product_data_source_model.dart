import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_sub_cartegory_widget.dart';
import 'package:flutter/material.dart';
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
        DataCell(ProductCartegoryWidget(cartegoryId: data[index].cartegoryId)),
        DataCell(ProductSubCartegoryWidget(id: data[index].subCartegoryId)),
        DataCell(Text(data[index].productVar)),
        DataCell(Text(data[index].sellingPrice.toString())),
        DataCell(CircleImageWidget(url: data[index].productImg!))
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
