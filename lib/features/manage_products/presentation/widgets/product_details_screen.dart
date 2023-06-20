import 'package:cached_network_image/cached_network_image.dart';
import 'package:field_zoom_pro_web/core/presentation/controllers/upload_image_controller.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final VoidCallback onEscape;
  const ProductDetailsScreen(
      {Key? key, required this.id, required this.onEscape})
      : super(key: key);

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _varController = TextEditingController();
  final _sysCodeController = TextEditingController();
  final _cartController = TextEditingController();
  final _subCartController = TextEditingController();
  bool isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _varController.dispose();
    _sysCodeController.dispose();
    _cartController.dispose();
    _subCartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadImageControllerProvider);
    final state2 = ref.watch(productsControllerProvider);
    ref.listen<AsyncValue>(uploadImageControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    ref.listen<AsyncValue>(productsControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    final productProv = ref.watch(watchProductProvider(widget.id));

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): widget.onEscape,
      },
      child: Focus(
        autofocus: true,
        child: productProv.when(
            data: (product) {
              _sysCodeController.text = product.systemCode;
              _nameController.text = product.name;
              _priceController.text = product.sellingPrice.toString();
              _varController.text = product.productVar.toString();
              _cartController.text = product.cartegoryId.toString();
              _subCartController.text = product.subCartegoryId.toString();
              return Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Edit Product",
                          style: Theme.of(context).textTheme.labelLarge),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                TextFormField(
                                  enabled: false,
                                  controller: _cartController,
                                  decoration: const InputDecoration(
                                    labelText: "Category Id",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid var";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  enabled: false,
                                  controller: _subCartController,
                                  decoration: const InputDecoration(
                                    labelText: "Sub Category Id",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid var";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _sysCodeController,
                                  decoration: const InputDecoration(
                                    labelText: "System Code",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid name";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autofocus: true,
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    labelText: "Selling Price",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid price";
                                    }
                                    if (double.tryParse(value) == null) {
                                      return "Please enter a valid price";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: _varController,
                                  decoration: const InputDecoration(
                                    labelText: "variation",
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid variation";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        MediaQuery.sizeOf(context).width * 0.5,
                                        50),
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: state.isLoading || state2.isLoading
                                      ? null
                                      : () async {
                                          final scaf =
                                              ScaffoldMessenger.of(context);
                                          if (!_key.currentState!.validate()) {
                                            return;
                                          }
                                          // TODO Change this to use a Product Model with copyWith
                                          final success = await ref
                                              .read(productsControllerProvider
                                                  .notifier)
                                              .editProductVariable(
                                            productId: widget.id,
                                            newInfo: {
                                              'systemCode': _sysCodeController
                                                  .text
                                                  .trim(),
                                              'name': _nameController.text,
                                              'sellingPrice': double.parse(
                                                  _priceController.text),
                                              'productVar': _varController.text
                                            },
                                          );
                                          if (success) {
                                            scaf.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Product details updated successfully",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: state.isLoading || state2.isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text("SAVE"),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 5,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.productImg!,
                                        height: 250,
                                        width: 250,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            final String? downloadUrl = await ref
                                                .read(
                                                    uploadImageControllerProvider
                                                        .notifier)
                                                .getUserDownloadUrl(
                                                    "PRODUCT_IMAGES");
                                            if (downloadUrl != null) {
                                              final success = await ref
                                                  .read(
                                                      productsControllerProvider
                                                          .notifier)
                                                  .updateProductByCompanyId(
                                                    product: product.copyWith(
                                                        productImg:
                                                            downloadUrl),
                                                  );
                                              if (success) {
                                                Fluttertoast.showToast(
                                                    msg: "SUCCESS :)");
                                              }
                                            }
                                          },
                                          icon: state.isLoading ||
                                                  state2.isLoading
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Icon(Icons.edit),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Center(child: Text("Something went wrong :("))),
      ),
    );
  }
}
