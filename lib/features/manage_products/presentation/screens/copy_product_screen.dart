import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class CopyProductScreen extends ConsumerStatefulWidget {
  final String selectedProductId;
  final Function() onCancel;
  const CopyProductScreen(
      {super.key, required this.selectedProductId, required this.onCancel});

  @override
  ConsumerState<CopyProductScreen> createState() => _CopyProductScreenState();
}

class _CopyProductScreenState extends ConsumerState<CopyProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pxController = TextEditingController();
  final _sysCodeController = TextEditingController();
  final _varController = TextEditingController();

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
    final state = ref.watch(productsControllerProvider);
    ref.listen<AsyncValue>(productsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    final productProv =
        ref.watch(watchProductProvider(widget.selectedProductId));

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: productProv.when(
            data: (product) {
              _nameController.text = product.name;
              _pxController.text = product.sellingPrice.toString();
              _varController.text = product.productVar;
              return Center(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("CLONE PRODUCT",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _sysCodeController,
                                    decoration: const InputDecoration(
                                      labelText: "System Code",
                                      border: OutlineInputBorder(),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
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
                                      if (value == null || value.isEmpty) {
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
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
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
                                      if (value == null || value.isEmpty) {
                                        return "Product variant is required";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            minimumSize: Size(
                                              MediaQuery.sizeOf(context).width *
                                                  0.3,
                                              50,
                                            ),
                                          ),
                                          onPressed: widget.onCancel,
                                          label: const Text("CANCEL"),
                                          icon: const Icon(Icons.cancel),
                                        ),
                                      ),
                                      const VerticalDivider(),
                                      Expanded(
                                        flex: 5,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                            MediaQuery.sizeOf(context).width *
                                                0.3,
                                            50,
                                          )),
                                          onPressed: state.isLoading
                                              ? null
                                              : () async {
                                                  if (!_formKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  final filter = ref.read(
                                                      filterNotifierProvider);
                                                  final nProduct = ProductModel(
                                                    id: DateHelpers
                                                        .dateTimeMillis(),
                                                    systemCode:
                                                        _sysCodeController.text,
                                                    name: _nameController.text,
                                                    companyId: filter
                                                        .loggedInuser!
                                                        .companyId,
                                                    cartegoryId:
                                                        product.cartegoryId,
                                                    subCartegoryId:
                                                        product.subCartegoryId,
                                                    sellingPrice: double.parse(
                                                        _pxController.text),
                                                    isActive: true,
                                                    productVar:
                                                        _varController.text,
                                                    productImg:
                                                        product.productImg,
                                                    createdAt: DateTime.now(),
                                                    addedBy:
                                                        filter.loggedInuser!.id,
                                                  );
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
                                                },
                                          label: state.isLoading
                                              ? const CircularProgressIndicator()
                                              : const Text("SAVE COPY"),
                                          icon: const Icon(Icons.save),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
