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
    return DataRow(
      cells: [
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].businessName)),
        DataCell(Text(data[index].businessType)),
        // DataCell(Text(data[index].regionId)),
        // DataCell(Text(data[index].routeId)),
        DataCell(Text(data[index].phoneNumber)),
        DataCell(Text(data[index].phoneNumberAlt)),
        DataCell(Text(data[index].district)),
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
