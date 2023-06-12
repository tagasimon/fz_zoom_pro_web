import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
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
    ref.listen<AsyncValue>(productsCartegoriesControllerProvider,
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration:
                          const InputDecoration(labelText: 'Cartegory Name'),
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
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              if (_nameController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Cartegory Name is required");
                                return;
                              }

                              final companyId = ref
                                  .watch(filterNotifierProvider)
                                  .user!
                                  .companyId;
                              final pdtCartegory = ProductCartegoryModel(
                                id: DateHelpers.dateTimeMillis(),
                                name: _nameController.text.toUpperCase(),
                                desc: _descriptionController.text,
                                companyId: companyId,
                                createdAt: DateTime.now(),
                              );
                              final success = await ref
                                  .read(productsCartegoriesControllerProvider
                                      .notifier)
                                  .addNewProductCategory(
                                      productCartegoryModel: pdtCartegory);
                              if (success) {
                                _nameController.clear();
                                _descriptionController.clear();
                                Fluttertoast.showToast(msg: "Cartegory Added");
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.3, 50),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('ADD CARTEGORY'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'PRODUCT CARTEGORIES',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    pdtCartProv.when(
                      data: (data) {
                        return DataTable(
                            showBottomBorder: true,
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            columns: const [
                              DataColumn(label: Text('NAME')),
                              DataColumn(label: Text('IMAGE')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('DESC')),
                            ],
                            rows: data.map((e) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(e.name)),
                                  DataCell(
                                      CircleImageWidget(url: e.cartegoryImg)),
                                  DataCell(
                                    Switch(
                                      value: e.isActive,
                                      onChanged: (val) {
                                        // TODO update isActive
                                      },
                                    ),
                                  ),
                                  DataCell(Text(e.desc)),
                                ],
                              );
                            }).toList());
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text(err.toString()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
