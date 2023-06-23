import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/product_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/alert_dialog_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/item_per_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';

class AddProductCartegoryScreen extends ConsumerStatefulWidget {
  const AddProductCartegoryScreen({super.key});

  @override
  ConsumerState<AddProductCartegoryScreen> createState() =>
      _AddProductCartegoryScreenState();
}

class _AddProductCartegoryScreenState
    extends ConsumerState<AddProductCartegoryScreen> {
  String? selectedId;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _newCartNameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _newCartNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsCartegoriesControllerProvider);
    final state2 = ref.watch(uploadImageControllerProvider);
    ref.listen<AsyncValue>(productsCartegoriesControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    ref.listen<AsyncValue>(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    final pdtCartProv = ref.watch(watchProductsCartegoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEW PRODUCT CARTEGORY'),
        centerTitle: true,
      ),
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): () =>
              context.pop(false),
        },
        child: Focus(
          autofocus: true,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: pdtCartProv.when(
                      data: (data) {
                        final source = CartegoriesDataSourceModel(
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
                          header: const Text('PRODUCT CARTEGORIES'),
                          columns: const [
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('IMAGE')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('# OF PRODUCTS')),
                          ],
                          source: source,
                          showFirstLastButtons: true,
                          rowsPerPage: ref
                              .watch(productFilterNotifierProvider)
                              .itemCount,
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
                                          title: 'Delete Cartegory',
                                          subTitle:
                                              'Are you sure you want to delete this Sub Cartegory, this action cannot be undone?'));
                                  if (confirm == null || !confirm) return;
                                  final companyId = ref
                                      .read(sessionNotifierProvider)
                                      .loggedInuser!
                                      .companyId;
                                  final success = await ref
                                      .read(
                                          productsCartegoriesControllerProvider
                                              .notifier)
                                      .deleteCartegoryById(
                                        companyId: companyId,
                                        cartegoryId: selectedId!,
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
                      error: (err, stack) => Text(err.toString()),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Add New',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Cartegory Name'),
                            ),
                            TextField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Cartegory Description'),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: state.isLoading || state2.isLoading
                                  ? null
                                  : () async {
                                      // TODO Check if the Cartegory Name already exists
                                      if (_nameController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Cartegory Name is required");
                                        return;
                                      }

                                      final companyId = ref
                                          .watch(sessionNotifierProvider)
                                          .loggedInuser!
                                          .companyId;
                                      final pdtCartegory =
                                          ProductCartegoryModel(
                                        id: DateHelpers.dateTimeMillis(),
                                        name:
                                            _nameController.text.toUpperCase(),
                                        desc: _descriptionController.text,
                                        companyId: companyId,
                                        createdAt: DateTime.now(),
                                      );
                                      final success = await ref
                                          .read(
                                              productsCartegoriesControllerProvider
                                                  .notifier)
                                          .addNewProductCategory(
                                              productCartegoryModel:
                                                  pdtCartegory);
                                      if (success) {
                                        _nameController.clear();
                                        _descriptionController.clear();
                                        Fluttertoast.showToast(
                                            msg: "Cartegory Added");
                                      }
                                    },
                              child: state.isLoading || state2.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('ADD CARTEGORY'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartegoriesDataSourceModel extends DataTableSource {
  final List<ProductCartegoryModel> data;
  final String? selectedId;
  final Function(String) onSelected;

  CartegoriesDataSourceModel({
    required this.data,
    required this.selectedId,
    required this.onSelected,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              return TextButton.icon(
                onPressed: () async {
                  final newCartNameController = TextEditingController();
                  newCartNameController.text = data[index].name;
                  final String? newCartName = await showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: newCartNameController,
                              decoration: const InputDecoration(
                                labelText: 'Edit Cartegory Name',
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
                  if (newCartName == null) return;
                  final success = await ref
                      .read(productsCartegoriesControllerProvider.notifier)
                      .updateProductCartegory(
                        companyId: ref
                            .read(sessionNotifierProvider)
                            .loggedInuser!
                            .companyId,
                        id: data[index].id,
                        productCartegoryModel: data[index]
                            .copyWith(name: newCartName.toUpperCase().trim()),
                      );
                  if (success) {
                    Fluttertoast.showToast(msg: "SUCCESS");
                  }
                },
                icon: const Icon(Icons.edit),
                label: Text(data[index].name),
              );
            },
          ),
        ),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              return CircleImageWidget(
                url: data[index].cartegoryImg,
                onTap: () async {
                  final companyId = ref
                      .watch(sessionNotifierProvider)
                      .loggedInuser!
                      .companyId;
                  final String? downloadUrl = await ref
                      .read(uploadImageControllerProvider.notifier)
                      .getUserDownloadUrl("PRODUCT_IMAGES");

                  if (downloadUrl != null) {
                    final nCart =
                        data[index].copyWith(cartegoryImg: downloadUrl);
                    final success = await ref
                        .read(productsCartegoriesControllerProvider.notifier)
                        .updateProductCartegory(
                            companyId: companyId,
                            id: data[index].id,
                            productCartegoryModel: nCart);
                    if (success) {
                      Fluttertoast.showToast(msg: "Image Updated");
                    }
                  }
                },
              );
            },
          ),
        ),
        DataCell(Consumer(
          builder: (context, ref, child) {
            return Switch(
              value: data[index].isActive,
              onChanged: (val) async {
                final success = await ref
                    .read(productsCartegoriesControllerProvider.notifier)
                    .updateProductCartegory(
                      companyId: ref
                          .read(sessionNotifierProvider)
                          .loggedInuser!
                          .companyId,
                      id: data[index].id,
                      productCartegoryModel:
                          data[index].copyWith(isActive: val),
                    );
                if (success) {
                  Fluttertoast.showToast(msg: "SUCCESS");
                }
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
            );
          },
        )),
        DataCell(
          Consumer(builder: (context, ref, child) {
            final numberOfProductsPrv =
                ref.watch(numOfProductsInCartegoryProvider(data[index].id));
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
