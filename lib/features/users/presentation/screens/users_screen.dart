import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/custom_switch_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/request_full_screen_widget.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/users_controller.dart';
import 'package:field_zoom_pro_web/features/users/presentation/widgets/users_table_actions_widget.dart';
import 'package:field_zoom_pro_web/features/users/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final state = ref.watch(usersControllerProvider);
    ref.listen(usersControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return Scaffold(
      appBar: AppBar(
        title: const CompanyTitleWidget(),
        actions: const [
          CustomSwitchWidget(),
          RequestFullScreenWidget(),
        ],
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
          );
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppFilterWidget(
                showRegionFilter: true,
                showSelectedUserFilter: false,
                showStartDateFilter: false,
                showEndDateFilter: false,
              ),
              const Divider(),
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
                            DataColumn(label: Text("IS ACTIVE")),
                            DataColumn(label: Text("COLLECT MONEY")),
                            DataColumn(label: Text("REQUIRE STOCK")),
                          ],
                          source: userData,
                          header: const Text("USERS"),
                          rowsPerPage: 10,
                          showCheckboxColumn: true,
                          showFirstLastButtons: true,
                          actions: const [
                            UsersTableActionsWidget(),
                          ]),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint("Error: $error");
          debugPrint("Stack: $stack");

          return const Center(child: Text("Error"));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class UsersDataSourceModel extends DataTableSource {
  final List<UserModel> data;
  final String? selectedUserId;
  final Function(String) onSelected;

  UsersDataSourceModel({
    required this.data,
    required this.selectedUserId,
    required this.onSelected,
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
        DataCell(GetRegionWidget(regionId: data[index].regionId)),
        DataCell(Consumer(builder: (context, ref, _) {
          final state = ref.watch(usersControllerProvider);
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Switch(
                  value: data[index].isActive,
                  onChanged: (val) async {
                    final nUser = data[index].copyWith(isActive: val);
                    await ref
                        .read(usersControllerProvider.notifier)
                        .updateUser(user: nUser);
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                );
        })),
        DataCell(Consumer(builder: (context, ref, _) {
          final state = ref.watch(usersControllerProvider);
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Switch(
                  value: data[index].isCollectionsRequired ?? true,
                  onChanged: (val) async {
                    final nUser =
                        data[index].copyWith(isCollectionsRequired: val);
                    await ref
                        .read(usersControllerProvider.notifier)
                        .updateUser(user: nUser);
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                );
        })),
        DataCell(Consumer(builder: (context, ref, _) {
          final state = ref.watch(usersControllerProvider);
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Switch(
                  value: data[index].isStockRequired ?? true,
                  onChanged: (val) async {
                    final nUser = data[index].copyWith(isStockRequired: val);
                    await ref
                        .read(usersControllerProvider.notifier)
                        .updateUser(user: nUser);
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                );
        })),
      ],
      selected: selectedUserId == data[index].id,
      onSelectChanged: (val) => onSelected(data[index].id),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedUserId == null ? 0 : 1;
}
