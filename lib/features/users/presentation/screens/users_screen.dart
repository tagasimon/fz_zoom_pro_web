import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/users/presentation/widgets/users_table_actions_widget.dart';
import 'package:field_zoom_pro_web/features/users/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class UsersScreen extends ConsumerStatefulWidget {
  static const routeName = "usersScreen";

  const UsersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  String? selectedUserId;
  @override
  Widget build(BuildContext context) {
    final niceTwoUsersProv = ref.watch(getUsersByCompanyAndRegionProvider);
    final state = ref.watch(userNotifierProvider);
    ref.listen(
      userNotifierProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, _) {
            final companyInfoProv = ref.watch(companyInfoProvider);
            return companyInfoProv.when(
              data: (data) => Text(data.companyName),
              error: (error, stackTrace) => const Text("Error"),
              loading: () => const Text("Loading ..."),
            );
          },
        ),
        centerTitle: true,
      ),
      body: niceTwoUsersProv.when(
        data: (data) {
          final userData = UsersDataSourceModel(
            data: data,
            selectedUserId: selectedUserId,
            onSelected: (user) async {
              if (selectedUserId == null) {
                setState(() => selectedUserId = user);
                return;
              }
              setState(() => selectedUserId = null);
            },
            onSwitchChanged: (val, id) async {
              await ref
                  .read(userNotifierProvider.notifier)
                  .updateUserStatus(isActive: val, id: id);
            },
          );
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppFilterWidget(
                showRegionFilter: true,
                showRouteFilter: false,
                showAssociateFilter: false,
                showEndDateFilter: true,
                showStartDateFilter: true,
              ),
              if (state.isLoading) const LinearProgressIndicator(),
              data.isEmpty
                  ? const Center(child: Text("No users found"))
                  : SizedBox(
                      width: double.infinity,
                      child: PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text("#")),
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("EMAIL")),
                          DataColumn(label: Text("PHONE")),
                          DataColumn(label: Text("ROLE")),
                          DataColumn(label: Text("REGION")),
                          DataColumn(label: Text("STATUS")),
                        ],
                        source: userData,
                        header: const Text("USERS"),
                        rowsPerPage: 10,
                        showCheckboxColumn: true,
                        showFirstLastButtons: true,
                        actions: selectedUserId == null
                            ? [const UsersTableActionsWidget()]
                            : [
                                TableActionWidget(
                                  title: "INSIGHTS",
                                  child: IconButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: "TODO");
                                    },
                                    icon: Icon(
                                      Icons.insights,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                      ),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text("Error")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

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
        DataCell(Text("${index + 1}")),
        DataCell(Text(data[index].name)),
        DataCell(Text(data[index].email)),
        DataCell(SelectableText(data[index].phoneNumber)),
        DataCell(Text(data[index].role)),
        DataCell(GetRegionWidget(regionId: data[index].regionId!)),
        DataCell(
          Switch(
            value: data[index].isActive,
            onChanged: (val) => onSwitchChanged(val, data[index].id),
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
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
