import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_cartegory_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

import 'package:field_zoom_pro_web/core/presentation/widgets/circle_image_widget.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
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
    final pdtCartProv = ref.watch(watchProductsCartegoriesProvider);
    final subCartProv = ref.watch(watchSubCartegoriesProvider);
    final state = ref.watch(subCartegoriesControllerProvider);
    ref.listen<AsyncValue>(subCartegoriesControllerProvider,
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                                    setState(() => selectedCartegory = value!);
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
                                  onPressed: state.isLoading
                                      ? null
                                      : () async {
                                          if (selectedCartegory == null) {
                                            Fluttertoast.showToast(
                                                msg: "Please Select Cartegory");
                                            return;
                                          }
                                          // TODO Use a better validation
                                          if (_nameController.text.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please Enter Sub Cartegory Name");
                                            return;
                                          }
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final companyId = ref
                                                .read(filterNotifierProvider)
                                                .user!
                                                .companyId;
                                            final subCartegory =
                                                SubCartegoryModel(
                                              id: DateHelpers.dateTimeMillis(),
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
                                                    subCartegory: subCartegory);
                                            if (success) {
                                              _nameController.clear();
                                              Fluttertoast.showToast(
                                                  msg: "Sub Cartegory Added");
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                          50),
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  child: state.isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('ADD'),
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
                    const SizedBox(height: 10),
                    const Text(
                      "SUB CARTERGORIES",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // TODO Use a Paginated DataTable
                    subCartProv.when(
                      data: (data) {
                        return DataTable(
                            showBottomBorder: true,
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            columns: const [
                              DataColumn(label: Text('NAME')),
                              DataColumn(label: Text('CARTEGORY')),
                              DataColumn(label: Text('IMAGE')),
                            ],
                            rows: data.map((e) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(e.name)),
                                  DataCell(ProductCartegoryWidget(
                                      cartegoryId: e.cartegoryId)),
                                  DataCell(CircleImageWidget(url: e.img!)),
                                ],
                              );
                            }).toList());
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(child: Text(e.toString())),
                    )
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
