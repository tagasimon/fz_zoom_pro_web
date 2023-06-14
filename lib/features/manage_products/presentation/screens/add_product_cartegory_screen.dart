import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
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
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
                          selectedId: null,
                          onSelected: (id) {},
                          onSwitchChanged: (val, id) {},
                        );
                        return PaginatedDataTable(
                          header: const Text('PRODUCT CARTEGORIES'),
                          columns: const [
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('IMAGE')),
                            DataColumn(label: Text('STATUS')),
                          ],
                          source: source,
                          showCheckboxColumn: false,
                          showFirstLastButtons: true,
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
                                      if (_nameController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Cartegory Name is required");
                                        return;
                                      }

                                      final companyId = ref
                                          .watch(filterNotifierProvider)
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
  final Function(bool, String) onSwitchChanged;

  CartegoriesDataSourceModel({
    required this.data,
    required this.selectedId,
    required this.onSelected,
    required this.onSwitchChanged,
  });
  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(data[index].name)),
        DataCell(
          Consumer(
            builder: (context, ref, child) {
              return CircleImageWidget(
                url: data[index].cartegoryImg,
                onTap: () async {
                  final companyId =
                      ref.watch(filterNotifierProvider).loggedInuser!.companyId;
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
        DataCell(
          Switch(
            value: data[index].isActive,
            onChanged: (val) => onSwitchChanged(val, data[index].id),
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
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
