import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/sub_cartegory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pxController = TextEditingController();
  final _sysCodeController = TextEditingController();
  final _varController = TextEditingController();
  ProductCartegoryModel? selectedCartegory;
  SubCartegoryModel? selectedSubCartegory;

  @override
  void dispose() {
    _nameController.dispose();
    _varController.dispose();
    _pxController.dispose();
    _sysCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdtCartProv = ref.watch(watchProductsCartegoriesProvider);
    final subCartProv = ref.watch(
        watchSubCartegoriesByCartegoryIdProvider(selectedCartegory?.id ?? ''));
    final state = ref.watch(productsControllerProvider);
    ref.listen<AsyncValue>(productsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("NEW PRODUCT"),
          ),
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  pdtCartProv.when(
                    data: (data) {
                      return DropdownButton<ProductCartegoryModel>(
                        hint: const Text("Select Cartegory"),
                        isExpanded: true,
                        value: selectedCartegory,
                        items: data
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e.name)))
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              selectedSubCartegory = null;
                              selectedCartegory = value!;
                            },
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text(e.toString())),
                  ),
                  const SizedBox(height: 10),
                  selectedCartegory == null
                      ? const Center(
                          child: Text("Select a cartegory to continue"),
                        )
                      : subCartProv.when(
                          data: (data) {
                            return Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        DropdownButton<SubCartegoryModel>(
                                          hint: const Text("Select Cartegory"),
                                          isExpanded: true,
                                          value: selectedSubCartegory,
                                          items: data
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name)))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() =>
                                                selectedSubCartegory = value!);
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _sysCodeController,
                                          decoration: const InputDecoration(
                                            labelText: "System Code",
                                            border: OutlineInputBorder(),
                                          ),
                                          // validator: (value) {
                                          //   if (value == null ||
                                          //       value.isEmpty) {
                                          //     return "System code is required";
                                          //   }
                                          //   return null;
                                          // },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: "Product Name",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Product name is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _pxController,
                                          decoration: const InputDecoration(
                                            labelText: "Product Price",
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Product price is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _varController,
                                          decoration: const InputDecoration(
                                            labelText: "Product Variant",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Product variant is required";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            50,
                                          )),
                                          onPressed: state.isLoading
                                              ? null
                                              : () async {
                                                  final nav =
                                                      Navigator.of(context);
                                                  if (!_formKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  if (selectedSubCartegory ==
                                                      null) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Select a sub cartegory to continue");
                                                    return;
                                                  }
                                                  final filter = ref.read(
                                                      filterNotifierProvider);
                                                  final nProduct = ProductModel(
                                                      id: DateHelpers
                                                          .dateTimeMillis(),
                                                      systemCode:
                                                          _sysCodeController
                                                              .text,
                                                      name:
                                                          _nameController.text,
                                                      companyId: filter
                                                          .loggedInuser!
                                                          .companyId,
                                                      cartegoryId:
                                                          selectedCartegory!.id,
                                                      subCartegoryId:
                                                          selectedSubCartegory!
                                                              .id,
                                                      sellingPrice:
                                                          double.parse(
                                                              _pxController
                                                                  .text),
                                                      isActive: true,
                                                      productVar:
                                                          _varController.text,
                                                      createdAt: DateTime.now(),
                                                      addedBy: filter
                                                          .loggedInuser!.id);
                                                  final success = await ref
                                                      .watch(
                                                          productsControllerProvider
                                                              .notifier)
                                                      .addNewProduct(
                                                          productModel:
                                                              nProduct);
                                                  if (success) {
                                                    Fluttertoast.showToast(
                                                        msg: "Success :)");
                                                  }
                                                  nav.pop();
                                                },
                                          child: state.isLoading
                                              ? const CircularProgressIndicator()
                                              : const Text("Add Product"),
                                        )
                                      ],
                                    ),
                                  ],
                                ));
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text(e.toString())),
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
