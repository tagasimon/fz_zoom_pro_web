import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/alert_dialog_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/item_per_page_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/sub_cartegory_provider.dart';

class AddSubCartegoryScreen extends ConsumerStatefulWidget {
  static const routeName = 'addSubCartegoryScreen';
  const AddSubCartegoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddSubCartegoryScreen> createState() =>
      _AddSubCartegoryScreenState();
}

class _AddSubCartegoryScreenState extends ConsumerState<AddSubCartegoryScreen> {
  String? selectedId;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  ProductCartegoryModel? selectedCartegory;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subCartegoriesControllerProvider);
    final state2 = ref.watch(uploadImageControllerProvider);
    final pdtCartProv = ref.watch(watchProductsCartegoriesProvider);
    final subCartProv = ref.watch(watchSubCartegoriesProvider);
    ref.listen<AsyncValue>(subCartegoriesControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    ref.listen<AsyncValue>(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: const Text('NEW SUB CARTEGORY')),
          body: Center(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: subCartProv.when(
                    data: (data) {
                      final source = SubCartegoriesDataSourceModel(
                        data: data,
                        selectedId: selectedId,
                        onSelected: (id) {
                          if (selectedId == null) {
                            setState(() => selectedId = id);
                            return;
                          }
                          setState(() => selectedId = null);
                        },
                      );
                      return PaginatedDataTable(
                        header: const Text('SUB CARTEGORIES'),
                        columns: const [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('NAME')),
                          DataColumn(label: Text('CARTEGORY')),
                          DataColumn(label: Text('IMAGE')),
                          DataColumn(label: Text('# OF PRODUCTS')),
                        ],
                        source: source,
                        showFirstLastButtons: true,
                        rowsPerPage:
                            ref.watch(productFilterNotifierProvider).itemCount,
                        actions: [
                          if (selectedId == null) const ItemPerPageWidget(),
                          if (selectedId != null)
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                final bool? confirm = await showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialogWidget(
                                        title: 'Delete Sub Cartegory',
                                        subTitle:
                                            'Are you sure you want to delete this Sub Cartegory, this action cannot be undone?'));
                                if (confirm == null || !confirm) return;
                                final companyId = ref
                                    .read(filterNotifierProvider)
                                    .loggedInuser!
                                    .companyId;
                                final success = await ref
                                    .read(subCartegoriesControllerProvider
                                        .notifier)
                                    .deleteSubCartegoryById(
                                      companyId: companyId,
                                      subCartid: selectedId!,
                                    );
                                if (success) {
                                  setState(() => selectedId = null);
                                  Fluttertoast.showToast(msg: "SUCCESS");
                                }
                              },
                              label: const Text('Delete'),
                              icon: const Icon(Icons.delete),
                            )
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text(e.toString())),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Column(
                      children: [
                        Text(
                          'Add New',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        pdtCartProv.when(
                          data: (data) {
                            return Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    DropdownButton<ProductCartegoryModel>(
                                      hint: const Text("Select Cartegory"),
                                      isExpanded: true,
                                      value: selectedCartegory,
                                      items: data
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e.name)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(
                                            () => selectedCartegory = value!);
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _nameController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Sub Cartegory Name',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Sub Cartegory Name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: state.isLoading ||
                                              state2.isLoading
                                          ? null
                                          : () async {
                                              // TODO Check if the Sub Cartegory Name already exists

                                              if (selectedCartegory == null) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Select Cartegory");
                                                return;
                                              }
                                              // TODO Use a better validation
                                              if (_nameController
                                                  .text.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Sub Cartegory Name");
                                                return;
                                              }
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final companyId = ref
                                                    .read(
                                                        filterNotifierProvider)
                                                    .loggedInuser!
                                                    .companyId;
                                                final subCartegory =
                                                    SubCartegoryModel(
                                                  id: DateHelpers
                                                      .dateTimeMillis(),
                                                  name: _nameController.text
                                                      .toUpperCase(),
                                                  companyId: companyId,
                                                  cartegoryId:
                                                      selectedCartegory!.id,
                                                );
                                                final success = await ref
                                                    .read(
                                                        subCartegoriesControllerProvider
                                                            .notifier)
                                                    .addNewSubProductCategory(
                                                        subCartegory:
                                                            subCartegory);
                                                if (success) {
                                                  _nameController.clear();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Sub Cartegory Added");
                                                }
                                              }
                                            },
                                      child: state.isLoading || state2.isLoading
                                          ? const CircularProgressIndicator()
                                          : const Text('ADD SUB CARTEGORY'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text(e.toString())),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubCartegoriesDataSourceModel extends DataTableSource {
  final List<SubCartegoryModel> data;
  final String? selectedId;
  final Function(String) onSelected;

  SubCartegoriesDataSourceModel({
    required this.data,
    required this.selectedId,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Consumer(
          builder: (context, ref, child) {
            return TextButton.icon(
              onPressed: () async {
                final newCartNameController = TextEditingController();
                newCartNameController.text = data[index].name;
                final String? newSubCartName = await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: newCartNameController,
                            decoration: const InputDecoration(
                              labelText: 'Edit Sub Cartegory Name',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              context.pop(newCartNameController.text);
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  },
                );
                if (newSubCartName == null) return;
                final success = await ref
                    .read(subCartegoriesControllerProvider.notifier)
                    .updateSubProductCartegory(
                      companyId: ref
                          .read(filterNotifierProvider)
                          .loggedInuser!
                          .companyId,
                      id: data[index].id,
                      subCartegoryModel: data[index]
                          .copyWith(name: newSubCartName.toUpperCase().trim()),
                    );
                if (success) {
                  Fluttertoast.showToast(msg: "SUCCESS");
                }
              },
              icon: const Icon(Icons.edit),
              label: Text(data[index].name),
            );
          },
        )),
        DataCell(ProductCartegoryWidget(cartegoryId: data[index].cartegoryId)),
        DataCell(Consumer(
          builder: (context, ref, child) {
            return CircleImageWidget(
              url: data[index].img!,
              onTap: () async {
                final companyId =
                    ref.watch(filterNotifierProvider).loggedInuser!.companyId;
                final String? downloadUrl = await ref
                    .read(uploadImageControllerProvider.notifier)
                    .getUserDownloadUrl("PRODUCT_IMAGES");
                if (downloadUrl != null) {
                  final nSubCart = data[index].copyWith(img: downloadUrl);
                  final success = await ref
                      .read(subCartegoriesControllerProvider.notifier)
                      .updateSubProductCartegory(
                          companyId: companyId,
                          id: data[index].id,
                          subCartegoryModel: nSubCart);
                  if (success) {
                    Fluttertoast.showToast(msg: "Image Updated");
                  }
                }
              },
            );
          },
        )),
        DataCell(
          Consumer(builder: (context, ref, child) {
            final numberOfProductsPrv =
                ref.watch(numOfProductsInSubCartegoryProvider(data[index].id));
            return numberOfProductsPrv.when(
              data: (data) => Text(data.toString()),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text(e.toString()),
            );
          }),
        ),
      ],
      selected: selectedId == data[index].id,
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
  int get selectedRowCount => selectedId == null ? 0 : 1;
}
