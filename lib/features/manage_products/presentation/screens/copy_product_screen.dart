import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
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
  final _retailPxController = TextEditingController();
  final _wholeSalePxController = TextEditingController();
  final _universePxController = TextEditingController();

  final _sysCodeController = TextEditingController();
  final _varController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _varController.dispose();
    _retailPxController.dispose();
    _wholeSalePxController.dispose();
    _universePxController.dispose();
    _sysCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsControllerProvider);
    final productProv =
        ref.watch(watchProductProvider(widget.selectedProductId));

    return productProv.when(
      data: (product) {
        _nameController.text = product.name;
        _wholeSalePxController.text = product.sellingPrice.toString();
        _retailPxController.text = product.wholesalePrice.toString();
        _universePxController.text = product.universePrice.toString();
        _varController.text = product.productVar;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("CLONE PRODUCT",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      controller: _universePxController,
                      decoration: const InputDecoration(
                        labelText: "Universe Price",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _retailPxController,
                      decoration: const InputDecoration(
                        labelText: "Sales Price",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Product Sale Price is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _wholeSalePxController,
                      decoration: const InputDecoration(
                        labelText: "Wholesale Price",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          flex: 5,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                              MediaQuery.sizeOf(context).width * 0.2,
                              50,
                            )),
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final filter =
                                        ref.read(sessionNotifierProvider);
                                    final nProduct = ProductModel(
                                      id: DateHelpers.dateTimeMillis(),
                                      systemCode: _sysCodeController.text,
                                      name: _nameController.text,
                                      companyId: filter.loggedInUser!.companyId,
                                      cartegoryId: product.cartegoryId,
                                      subCartegoryId: product.subCartegoryId,
                                      sellingPrice: double.parse(
                                          _retailPxController.text),
                                      wholesalePrice:
                                          _wholeSalePxController.text == ""
                                              ? double.parse(
                                                  _retailPxController.text)
                                              : double.parse(
                                                  _wholeSalePxController.text),
                                      universePrice:
                                          _universePxController.text == ""
                                              ? double.parse(
                                                  _retailPxController.text)
                                              : double.parse(
                                                  _universePxController.text),
                                      isActive: true,
                                      productVar: _varController.text,
                                      productImg: product.productImg,
                                      createdAt: DateTime.now(),
                                      addedBy: filter.loggedInUser!.id,
                                    );
                                    final success = await ref
                                        .watch(
                                            productsControllerProvider.notifier)
                                        .addNewProduct(productModel: nProduct);
                                    if (success) {
                                      widget.onCancel();
                                      Fluttertoast.showToast(msg: "Success :)");
                                    }
                                  },
                            label: state.isLoading
                                ? const CircularProgressIndicator()
                                : const Text("SAVE COPY"),
                            icon: const Icon(Icons.save),
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              minimumSize: Size(
                                MediaQuery.sizeOf(context).width * 0.3,
                                50,
                              ),
                            ),
                            onPressed: widget.onCancel,
                            label: const Text("CANCEL"),
                            icon: const Icon(Icons.cancel),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(
        child: Text(
          "Something went Wrong :(",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
