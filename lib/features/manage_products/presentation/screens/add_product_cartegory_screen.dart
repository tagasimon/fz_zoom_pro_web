import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_cartegory_provider%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class AddProductCartegoryScreen extends ConsumerStatefulWidget {
  const AddProductCartegoryScreen({super.key});

  @override
  ConsumerState<AddProductCartegoryScreen> createState() =>
      _AddProductCartegoryScreenState();
}

class _AddProductCartegoryScreenState
    extends ConsumerState<AddProductCartegoryScreen> {
  var newCartegoryName = "";
  var newCartegoryDesc = "";

  @override
  Widget build(BuildContext context) {
    final pdtCartControllerState =
        ref.watch(productsCartegoriesControllerProvider);
    ref.listen<AsyncValue>(productsCartegoriesControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Cartegory'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Cartegory Name'),
              onChanged: (val) => newCartegoryName = val,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(labelText: 'Cartegory Description'),
              maxLines: 2,
              onChanged: (val) => newCartegoryDesc = val,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pdtCartControllerState.isLoading
                  ? null
                  : () async {
                      final nav = Navigator.of(context);

                      final companyId =
                          ref.watch(filterNotifierProvider).user!.companyId;
                      final pdtCartegory = ProductCartegoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        name: newCartegoryName.toUpperCase(),
                        desc: newCartegoryDesc,
                        companyId: companyId,
                        createdAt: DateTime.now(),
                      );
                      final success = await ref
                          .read(productsCartegoriesControllerProvider.notifier)
                          .addNewProductCategory(
                              productCartegoryModel: pdtCartegory);
                      if (success) {
                        Fluttertoast.showToast(msg: "Cartegory Added");
                        nav.pop();
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
              ),
              child: pdtCartControllerState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('ADD CARTEGORY'),
            ),
          ],
        ),
      ),
    );
  }
}
