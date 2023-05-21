import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class UsersDataSourceModel extends DataTableSource {
  final List<UserModel> data;
  final String? selectedUserId;
  final Function(String) onSelected;
  final Function(bool, String) onSwitchChanged;

  UsersDataSourceModel({
    required this.data,
    required this.selectedUserId,
    required this.onSelected,
    required this.onSwitchChanged,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].email)),
        DataCell(SelectableText(data[index].phoneNumber)),
        DataCell(Text(data[index].role)),
        DataCell(
          Consumer(builder: (context, ref, _) {
            String? regionId = data[index].regionId;
            if (regionId == null || regionId.isEmpty) {
              return const Text('Not Found');
            }
            final regionProv =
                ref.watch(getRegionByCompanyIdProvider(regionId));
            return regionProv.when(
              data: (region) {
                return Text(region.name);
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            );
          }),
        ),
        DataCell(
          CupertinoSwitch(
            value: data[index].isActive,
            onChanged: (val) => onSwitchChanged(val, data[index].id),
          ),
        ),
      ],
      selected: selectedUserId == data[index].id,
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
  int get selectedRowCount => selectedUserId == null ? 0 : 1;
}
