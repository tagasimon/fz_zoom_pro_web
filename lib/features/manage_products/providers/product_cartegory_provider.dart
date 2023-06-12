import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/controllers/product_cartegories_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final productsCartegoryProvider =
    Provider<CartegoryRepository>((ref) => CartegoryRepository());

final watchProductsCartegoriesProvider =
    StreamProvider<List<ProductCartegoryModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;

  return ref
      .watch(productsCartegoryProvider)
      .watchProductCatergories(companyId: companyId);
});

final productCartegoryByIdProvider =
    FutureProvider.family.autoDispose<ProductCartegoryModel, String>((ref, id) {
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;
  return ref
      .watch(productsCartegoryProvider)
      .getProductCartegoryById(id: id, companyId: companyId);
});

final productsCartegoriesControllerProvider =
    StateNotifierProvider<ProductCartegoriesController, AsyncValue>((ref) {
  return ProductCartegoriesController();
});
