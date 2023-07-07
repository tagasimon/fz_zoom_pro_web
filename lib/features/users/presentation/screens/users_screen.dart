import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_app_bar_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/users_controller.dart';
import 'package:field_zoom_pro_web/features/users/presentation/widgets/users_table_actions_widget.dart';
import 'package:field_zoom_pro_web/features/users/presentation/widgets/users_table_switch_widget.dart';
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
    final state = ref.watch(usersControllerProvider);
    ref.listen(usersControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return Scaffold(
      appBar: const CompanyAppBarWidget(title: "USERS") as PreferredSizeWidget?,
      // AppBar(
      //   title: const CompanyAppBarWidget(),
      //   actions: const [
      //     CustomSwitchWidget(),
      //     RequestFullScreenWidget(),
      //   ],
      // ),
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
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("EMAIL")),
                          DataColumn(label: Text("PHONE")),
                          DataColumn(label: Text("ROLE")),
                          DataColumn(label: Text("REGION")),
                          DataColumn(label: Text("ACTIVE")),
                          DataColumn(label: Text("REQUIRE STOCK")),
                          DataColumn(label: Text("COLLECT MONEY")),
                          DataColumn(label: Text("CAN REGISTER CUSTOMERS")),
                          DataColumn(label: Text("CAN DELIVER ORDER")),
                          DataColumn(label: Text("CAN GIVE DISCOUNT")),
                          DataColumn(label: Text("CAN SELL WHOLESALE")),
                          DataColumn(label: Text("CAN CREATE ROUTES")),
                        ],
                        source: userData,
                        header: const Text("USERS"),
                        rowsPerPage: 10,
                        showCheckboxColumn: true,
                        showFirstLastButtons: true,
                        actions: [
                          if (state.isLoading)
                            const CircularProgressIndicator(),
                          const UsersTableActionsWidget(),
                        ],
                      ),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text("Something went wrong :(")),
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
    final List<Map<String, String>> roles = [
      {"role": "Super Admin", "level": "5"},
      {"role": "Admin", "level": "3"},
      {"role": "Manager", "level": "2"},
      {"role": "Sales Rep", "level": "1"},
    ];
    return DataRow(
      cells: [
        DataCell(Consumer(
          builder: (context, ref, _) {
            return TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                suffix: Icon(Icons.edit, size: 16, color: Colors.grey),
              ),
              controller: TextEditingController(text: data[index].name),
              onSubmitted: (value) async {
                final newName = value.trim();
                if (newName.isEmpty) return;
                final nUser = data[index].copyWith(name: newName);
                final success = await ref
                    .read(usersControllerProvider.notifier)
                    .updateUser(user: nUser);
                if (success) {
                  Fluttertoast.showToast(msg: "SUCCESS :)");
                }
              },
            );
          },
        )),
        DataCell(Text(data[index].email)),
        DataCell(SelectableText(data[index].phoneNumber)),
        DataCell(Consumer(
          builder: (context, ref, _) {
            // return dropdown menu for roles
            return DropdownButton<String>(
              value: data[index].role,
              onChanged: (String? newValue) async {
                if (newValue == null) return;
                final selected = roles.firstWhere((e) => e["role"] == newValue);
                if (selected["level"] == "5") {
                  Fluttertoast.showToast(msg: "You can't set this role");
                  return;
                }
                final nUser = data[index].copyWith(
                  role: selected["role"],
                  level: int.parse(selected["level"]!),
                );
                await ref
                    .read(usersControllerProvider.notifier)
                    .updateUser(user: nUser);
              },
              items:
                  roles.map<DropdownMenuItem<String>>((Map<String, String> e) {
                return DropdownMenuItem<String>(
                  value: e["role"],
                  child: Text(e["role"]!),
                );
              }).toList(),
            );
          },
        )),
        DataCell(Consumer(
          builder: (context, ref, child) {
            final regionsProv = ref.watch(allRegionsProvider);
            return regionsProv.when(
              data: (regionsList) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetRegionWidget(regionId: data[index].regionId),
                    DropdownButton<String?>(
                        value: null,
                        onChanged: (String? value) async {
                          if (value == null) return;
                          final nUser = data[index].copyWith(regionId: value);
                          final success = await ref
                              .read(usersControllerProvider.notifier)
                              .updateUser(user: nUser);
                          if (success) {
                            Fluttertoast.showToast(msg: "SUCCESS :)");
                          }
                        },
                        items: regionsList
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e.id,
                                child: Text(e.name),
                              ),
                            )
                            .toList())
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const SizedBox.shrink(),
            );
          },
        )),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index].copyWith(isActive: !data[index].isActive),
            value: data[index].isActive,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index]
                .copyWith(isStockRequired: !data[index].isStockRequired!),
            value: data[index].isStockRequired!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index].copyWith(
                isCollectionsRequired: !data[index].isCollectionsRequired!),
            value: data[index].isCollectionsRequired!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index].copyWith(
                canRegisterCustomers: !data[index].canRegisterCustomers!),
            value: data[index].canRegisterCustomers!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index].copyWith(
                canConfirmOrderDelivery: !data[index].canConfirmOrderDelivery!),
            value: data[index].canConfirmOrderDelivery!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index]
                .copyWith(canGiveDiscount: !data[index].canGiveDiscount!),
            value: data[index].canGiveDiscount!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index]
                .copyWith(canSellAtWholesale: !data[index].canSellAtWholesale!),
            value: data[index].canSellAtWholesale!,
          ),
        ),
        DataCell(
          UsersTableSwitchWidget(
            nUser: data[index]
                .copyWith(canCreateRoutes: !data[index].canCreateRoutes!),
            value: data[index].canCreateRoutes!,
          ),
        ),
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
