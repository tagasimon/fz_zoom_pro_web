import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/features/users/models/users_data_source_model.dart';
import 'package:field_zoom_pro_web/features/users/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("USERS"),
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
          );
          return Column(
            children: [
              const AppFilterWidget(
                showRegionFilter: true,
                showRouteFilter: false,
                showAssociateFilter: false,
                showEndDateFilter: true,
                showStartDateFilter: true,
              ),
              data.isEmpty
                  ? const Center(child: Text("No users found"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: PaginatedDataTable(
                        columns: const [
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("EMAIL")),
                          DataColumn(label: Text("PHONE")),
                          DataColumn(label: Text("ROLE")),
                          DataColumn(label: Text("REGION")),
                          DataColumn(label: Text("STATUS")),
                        ],
                        source: userData,
                        header: const Text("ALL USERS"),
                        rowsPerPage: 10,
                        actions: selectedUserId == null
                            ? [
                                const Text(
                                  "Select a user to view actions",
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16),
                                )
                              ]
                            : [
                                // NiceTwoTableActionsWidget(
                                //     selectedUserId: selectedUserId!),
                                // TextButton.icon(
                                //   onPressed: () {
                                //     setState(() => selectedUserId = null);
                                //   },
                                //   icon: const Icon(Icons.clear),
                                //   label: const Text('Clear Selection'),
                                //   style: TextButton.styleFrom(
                                //       foregroundColor: Colors.red),
                                // ),
                              ],
                      ),
                    ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text("Error")),
      ),
    );
  }
}
