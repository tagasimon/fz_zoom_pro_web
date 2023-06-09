import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/controllers/products_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final productsRepoProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(ref.watch(firestoreInstanceProvider));
});

final watchProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(productsRepoProvider)
      .watchProductsStream(companyId: companyId);
});

final watchProductProvider =
    StreamProvider.family.autoDispose<ProductModel, String>((ref, id) {
  return ref.watch(productsRepoProvider).watchProduct(id: id);
});

final productsControllerProvider =
    StateNotifierProvider.autoDispose<ProductsController, AsyncValue>((ref) {
  return ProductsController(ref.watch(firestoreInstanceProvider));
});
