import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_route_widget.dart';
import 'package:flutter/material.dart';
import 'package:fz_hooks/fz_hooks.dart';
import 'package:intl/intl.dart';

class CustomerDataSourceModel extends DataTableSource {
  final List<CustomerModel> data;
  final Set<CustomerModel> selectedCustomers;
  final Function(CustomerModel customer) onSelected;

  final dateFormat = DateFormat("dd/MM/yyyy");

  CustomerDataSourceModel({
    required this.data,
    required this.selectedCustomers,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    final number = index + 1;
    return DataRow(
      cells: [
        DataCell(Text(number.toString())),
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].businessName)),
        DataCell(Text(data[index].businessType)),
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(GetRouteWidget(routeId: data[index].routeId)),
        DataCell(Text(data[index].phoneNumber)),
        DataCell(Text(data[index].district)),
        DataCell(Text("${data[index].latitude} , ${data[index].longitude}")),
        DataCell(Text(data[index].locationDescription)),
      ],
      selected: selectedCustomers.contains(data[index]),
      onSelectChanged: (val) {
        onSelected(data[index]);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedCustomers.length;
}
