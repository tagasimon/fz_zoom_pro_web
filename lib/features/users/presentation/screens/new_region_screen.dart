import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/regions_controller.dart';
import 'package:field_zoom_pro_web/features/users/providers/regions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class NewRegionScreen extends ConsumerStatefulWidget {
  const NewRegionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewRegionScreen> createState() => _NewRegionScreenState();
}

class _NewRegionScreenState extends ConsumerState<NewRegionScreen> {
  // String _name = "";
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(regionsControllerProvider);
    final regionsProv = ref.watch(companyRegionsProvider);
    ref.listen<AsyncValue>(regionsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text("NEW REGION"), centerTitle: true),
          body: Center(
            child: regionsProv.when(
              data: (data) {
                final source =
                    RegionsDataSourceModel(data: data, selectedId: null);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: PaginatedDataTable(
                        header: const Text("REGIONS"),
                        columns: const [
                          DataColumn(label: Text("#")),
                          DataColumn(label: Text("NAME")),
                        ],
                        source: source,
                        showCheckboxColumn: false,
                        showFirstLastButtons: true,
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text("Add New"),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Enter New Region"),
                              validator: (String? val) {
                                if (val == null || val.isEmpty) {
                                  return 'Region Name Missing';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                      final companyId = ref
                                          .read(sessionNotifierProvider)
                                          .loggedInUser!
                                          .companyId;
                                      if (_formKey.currentState!.validate()) {
                                        final region = RegionModel(
                                          id: DateHelpers.dateTimeMillis(),
                                          name: _nameController.text
                                              .trim()
                                              .toLowerCase(),
                                          companyId: companyId,
                                          lastUpdated: DateTime.now(),
                                          date: DateTime.now(),
                                        );

                                        final success = await ref
                                            .read(regionsControllerProvider
                                                .notifier)
                                            .addNewRegion(region: region);
                                        if (success) {
                                          _nameController.clear();
                                          Fluttertoast.showToast(
                                              msg: "SUCCESS :)");
                                        }
                                      }
                                    },
                              child: state.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "ADD REGION",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegionsDataSourceModel extends DataTableSource {
  final List<RegionModel> data;
  final String? selectedId;
  final Function(String)? onSelected;

  RegionsDataSourceModel({
    required this.data,
    required this.selectedId,
    this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(data[index].name)),
      ],
      selected: selectedId == data[index].id,
      onSelectChanged: (val) {
        if (val == true) {
          onSelected!(data[index].id);
        }
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedId == null ? 0 : 1;
}
