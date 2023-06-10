import 'package:cached_network_image/cached_network_image.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final Function(bool) isDone;
  const ProductDetailsScreen({Key? key, required this.id, required this.isDone})
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
  final _cartController = TextEditingController();
  final _subCartController = TextEditingController();
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    final productProv = ref.watch(watchProductProvider(widget.id));
    final editProductState = ref.watch(productsControllerProvider);

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () {
          widget.isDone(false);
        },
      },
      child: Focus(
        autofocus: true,
        child: productProv.when(
          data: (product) {
            _nameController.text = product.name;
            _priceController.text = product.sellingPrice.toString();
            _varController.text = product.productVar.toString();
            _cartController.text = product.cartegoryId.toString();
            _subCartController.text = product.subCartegoryId.toString();
            return Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                              labelText: "var",
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.5, 50),
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onPressed: editProductState.isLoading
                                ? null
                                : () async {
                                    if (!_key.currentState!.validate()) {
                                      return;
                                    }
                                    // TODO Change this to use a Product Model with copyWith
                                    final success = await ref
                                        .read(
                                            productsControllerProvider.notifier)
                                        .editProductVariable(
                                      productId: widget.id,
                                      newInfo: {
                                        'name': _nameController.text,
                                        'sellingPrice':
                                            double.parse(_priceController.text),
                                        'productVar': _varController.text
                                      },
                                    );
                                    if (success) {
                                      widget.isDone(true);
                                    }
                                  },
                            child: editProductState.isLoading
                                ? const CircularProgressIndicator()
                                : const Text("SAVE"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
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
                                      // final success = await ref
                                      //     .read(
                                      //         productsControllerProvider.notifier)
                                      //     .deleteProduct(
                                      //       productId: widget.id,
                                      //     );
                                      // if (success) {
                                      //   widget.isDone(true);
                                      // }
                                    },
                                    icon: const Icon(Icons.edit),
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
              ),
            );
          },
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) => const Scaffold(
              body: Center(child: Text("Something went wrong :("))),
        ),
      ),
    );
  }
}
