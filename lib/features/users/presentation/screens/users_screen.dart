import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/users/models/users_data_source_model.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/new_region_screen.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/new_user_screen.dart';
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
                      width: MediaQuery.of(context).size.width * 0.6,
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
                        header: const Text("USERS"),
                        rowsPerPage: 10,
                        actions: selectedUserId == null
                            ? [
                                const VerticalDivider(),
                                TableActionWidget(
                                  title: "NEW REGION",
                                  child: IconButton(
                                    onPressed: () => context.push(
                                        const NewRegionScreen(),
                                        fullscreenDialog: true),
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                                const VerticalDivider(),
                                TableActionWidget(
                                  title: "NEW USER",
                                  child: IconButton(
                                    onPressed: () => context.push(
                                        const NewUserScreen(),
                                        fullscreenDialog: true),
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                                const VerticalDivider(),
                                TableActionWidget(
                                  title: "INSIGHTS",
                                  child: IconButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: "TODO");
                                    },
                                    icon: const Icon(Icons.insights),
                                  ),
                                ),
                              ]
                            : [
                                TableActionWidget(
                                  title: "INSIGHTS",
                                  child: IconButton(
                                    onPressed: () {},
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
